class RemoveLimitFromBodyString < ActiveRecord::Migration
  def change
    change_column :statuses, :body, :string, :limit => 255
  end
end
