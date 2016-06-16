class ImportController < ApplicationController
  
  def index

  end

  def importstatus
  	@uploaded_io = params[:file]
    @filePath = Rails.root.join('tmp', 'cache', @uploaded_io.original_filename)
    @process_info = {:errors => 0, :imports => 0, :updates_or_duplicates => 0, :fileInfo => ""}
    upload
  end

  def upload
      
      filename = @uploaded_io.original_filename.downcase
    	File.open(@filePath, 'wb') do |file|
    		file.write(@uploaded_io.read)
        file.close
  		end  		
  		
      
      if(filename.end_with?('.csv'))
        # Load CSV file
        require 'roo'
        @csvFile = Roo::CSV.new(@filePath, csv_options: {col_sep: ';', quote_char: '"'})
    		
        # assume content by filename
        if(filename.include?("orderitems_auto_stat"))
    			@process_info[:fileInfo] =  "order_items -> ok"
    			import_orders
    		elsif(filename.include? "artikelpakete")
    			@process_info[:fileInfo] = "item_bundles -> ok"
    			import_items_bundles
    		elsif(filename.include? "item_auto_stat")
    			@process_info[:fileInfo] = "items -> ok"
          import_items          
    		else
    			@process_info[:fileInfo] = "kein match - Dateiname nicht zuordbar"
          @process_info[:errors] = @process_info[:errors] + 1          
        end
      else
        @process_info[:fileInfo] = "Abbruch, keine .csv Datei"
        @process_info[:errors] = @process_info[:errors] + 1                    
      end
      #delete temp file
      deleteTmpFile    		
  	end

  	def import_items
      
      #check for column matches in row = 1
      row = 1
      if(@csvFile.cell(row, 1).to_s) != "ItemID" 
        OR (@csvFile.cell(row, 2).to_s) != "ItemNo" 
        OR (@csvFile.cell(row, 3).to_s) != "ItemTextName" 
        OR (@csvFile.cell(row, 4).to_s) != "ItemProducer"

        @process_info[:fileInfo] = "Abbruch, Spalten nicht zuordbar"
        @process_info[:errors] += 1
              
      else
        #columns ok -> write Items
        row = 2
        while row <= @csvFile.last_row

          begin
            item = Item.find_by!(item_id: @csvFile.cell(row, 1).to_i)
            item.update(item_number: @csvFile.cell(row, 2), 
                      item_name: @csvFile.cell(row, 3), 
                      item_manufacturer: @csvFile.cell(row, 4))
            @process_info[:updates_or_duplicates] += 1            
          rescue ActiveRecord::RecordNotFound
            Item.create(id: @csvFile.cell(row, 1).to_i, 
                      item_id: @csvFile.cell(row, 1).to_i, 
                      item_number: @csvFile.cell(row, 2), 
                      item_name: @csvFile.cell(row, 3), 
                      item_manufacturer: @csvFile.cell(row, 4))
          end
          row += 1
        end
        @process_info[:errors] = 0
        @process_info[:imports] = row - 2 - @process_info[:updates_or_duplicates]
      end      
  	end

  	def import_orders
      #check for column matches in row = 1
      row = 1
      if (@csvFile.cell(row, 1).to_s) != "order_id" 
            OR (@csvFile.cell(row, 2).to_s) != "item_id" 
            OR (@csvFile.cell(row, 3).to_s) != "item_quantity" 
            OR (@csvFile.cell(row, 4).to_s) != "order_amount" 
            OR (@csvFile.cell(row, 5).to_s) != "order_timestamp" 
            OR (@csvFile.cell(row, 6).to_s) != "order_referrer"

        @process_info[:fileInfo] = "Abbruch, Spalten nicht zuordbar"
        @process_info[:errors] += 1
            
      else 
      #columns ok -> write Items
        row = 2
      while row <= @csvFile.last_row 
          Order.create(order_id: @csvFile.cell(row, 1).to_i, 
          item_id: @csvFile.cell(row, 2).to_i, 
          item_quantity: @csvFile.cell(row, 3),
          order_amount: @csvFile.cell(row, 4), 
          created_at: @csvFile.cell(row, 5),
          order_referrer: @csvFile.cell(row, 6))
        row += 1
      end
      end      
      
      @process_info[:errors] = 0
      @process_info[:imports] = row - 2 - @process_info[:updates_or_duplicates]
      
    end
  	


  	def import_items_bundles

      #check for column matches in row = 1
      row = 1
      if (@csvFile.cell(row, 1).to_s) != "article_id" 
            OR (@csvFile.cell(row, 2).to_s) != "article_source_id" 
            OR (@csvFile.cell(row, 5).to_s) != "quantity"             

        @process_info[:fileInfo] = "Abbruch, Spalten nicht zuordbar"
        @process_info[:errors] += 1
            
      else #columns ok -> write Items
          row = 2
          while row <= @csvFile.last_row
            ItemBundle.create(item_id: @csvFile.cell(row, 1).to_i, 
            item_source_id: @csvFile.cell(row, 2).to_i, 
            item_source_quantity: @csvFile.cell(row, 5).to_i)
            row += 1
          end
        
      end
      @process_info[:errors] = 0
      @process_info[:imports] = row - 2 - @process_info[:updates_or_duplicates]

  	end

    def deleteTmpFile
      #delete temp file
      File.unlink(@filePath)
    end

end
