class CollectionsController < ApplicationController
  def show
    @collection = Collection.find params[:id]
    if @collection.items.count == 0
      @items1, @items2 = [[],[]]
    else  
      count = @collection.items.count

      @items1, @items2 = @collection.items.sort_by {|item| item.name}
                          .in_groups_of((count / 2 ) + (count % 2))
      @items1.compact!
      @items2.compact!
    end
  end
end
