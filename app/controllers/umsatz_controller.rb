class UmsatzController < ApplicationController
  
  def index
    p_length = 500
    @page = 0;
    @max_page_reached = false
    @min_page_reached = false
    @weeks = [ :w1, :w2, :w3, :w4, :w5, :w6, :w7, :w8, :w9, :w10, :w11, :w12, :w53, :w54, :w55, :w56, :w105, :w106, :w107, :w108 ]
    @search_string = "EVOGWVW13"
    query =  'Select * from items'
  	
    if params[:p]      
      @page = params[:p].to_i
      if @page.to_i < 0
        @page = 0 
      end
      logger.info("------page: " + params[:p])    
    end

    if params[:search]
      @search_string = params[:search]
      #query = build_query(weeks, @search_string)
    end    

    query = build_query(@weeks, @search_string)
    query += ' LIMIT ' + (p_length + 1 ).to_s + ' OFFSET ' + (@page.to_i * p_length).to_s
    logger.info("---------query: " + query.to_s)
    
    @items = Item.find_by_sql(query)
      

      
    #check if 'next Page' OR 'previous Page' is needed
    if @items.length <= p_length
      @max_page_reached = true
    end
    if @page == 0
      @min_page_reached = true
    end
    @items = @items.first(p_length)
    
    #respond
    respond_to do |format|
      format.html { render :index }
      format.json { render :json }
      format.js
    end
  end

  private
    def get_start_date(i)
      monday = Date.today - i.weeks

      while !monday.monday?
        monday = monday - 1.days
      end
      return monday
    end

    def build_query(weeks, search_item_number)
      query = 'SELECT * from items '
      weeks.each do |week|        
        start_date = get_start_date(week.to_s.split('w')[1].to_i)
        end_date = start_date + 6.days

        query += ' LEFT JOIN '
        query += ' ( SELECT orders.item_id, week(orders.created_at, 3) `' + week.to_s + '`, sum(orders.item_quantity)  `' + week.to_s + 'q`'
        query += ' FROM orders '
        query += ' WHERE created_at BETWEEN CAST("' + start_date.to_s + '" AS DATE) AND CAST("' + end_date.to_s + '" AS DATE ) '
        query += ' group by `item_id`, `' + week.to_s + '`) '
        query += ' as orders' + week.to_s + ' ON items.item_id = orders' + week.to_s + '.item_id '
      end
      query += ' WHERE items.item_id in '
      query += ' ( SELECT item_bundles.item_id from item_bundles, items '
      query += ' where '
      query += ' items.item_number like "%' + search_item_number.to_s + '%" '
      query += ' AND items.item_id = item_bundles.item_source_id ) '
      query += ' OR items.item_number like "%' + search_item_number.to_s + '%"'
    end
   
end