class AddDepartmentIdToEvents < ActiveRecord::Migration
  def change
    add_column :la_department_watcher_events, :department_id, :integer
    add_index :la_department_watcher_events, :department_id
  end
end
