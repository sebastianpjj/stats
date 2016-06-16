$(document).ready( function(){
	resize_table_head();	
	highlight_differences()
}
); 



function resize_table_head()
{
	var cols = $('#sales_table_head thead tr th');
	
	for(i = 0; i < cols.length; i++) 
	{
		var j = i + 1;
		
		$(cols[i]).css({
			"width": $('#sales_table tbody tr td:nth-child(' + j + ')').outerWidth(),
			"padding": $('#sales_table tbody tr td:nth-child(' + j + ')').css("padding"),
			"border": $('#sales_table tbody tr td:nth-child(' + j + ')').css("border")
			});
	}
}

function highlight_differences()
{
	$('#sales_table tbody tr').each(function(){
		
		var values = $(this).find('.values_4weeks')
		for(i = values.length - 2; i >= 0 ; i--)
		{
			
			var valthis = parseInt($(values[i]).text());
			var valprev = parseInt($(values[i + 1]).text());
			
			if(valthis > valprev * 1.5)
			{
				$(values[i]).addClass('highlight_green60');
			}			
			else if(valthis > valprev * 1.4)
			{
				$(values[i]).addClass('highlight_green50');
			}
			else if(valthis > valprev * 1.3)
			{
				$(values[i]).addClass('highlight_green40');
			}
			else if(valthis > valprev * 1.2)
			{
				$(values[i]).addClass('highlight_green30');
			}
			else if(valthis > valprev * 1.1)
			{
				$(values[i]).addClass('highlight_green20');
			}
			else if(valthis > valprev)
			{
				$(values[i]).addClass('highlight_green10');
			}
			else if(valthis < valprev / 1.5)
			{
				$(values[i]).addClass('highlight_red60');
			}
			else if(valthis < valprev / 1.4)
			{
				$(values[i]).addClass('highlight_red50');
			}
			else if(valthis < valprev / 1.3)
			{
				$(values[i]).addClass('highlight_red40');
			}
			else if(valthis < valprev / 1.2)
			{
				$(values[i]).addClass('highlight_red30');
			}
			else if(valthis < valprev / 1.1)
			{
				$(values[i]).addClass('highlight_red20');
			}
			else if(valthis < valprev)
			{
				$(values[i]).addClass('highlight_red10');
			}
		}
	});
		
}