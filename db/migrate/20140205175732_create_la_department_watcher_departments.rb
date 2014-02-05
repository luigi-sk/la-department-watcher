class CreateLaDepartmentWatcherDepartments < ActiveRecord::Migration
  def change
    create_table :la_department_watcher_departments do |t|
      t.string :departmentid
      t.string :name
      t.string :onlinestatus
      t.string :presetstatus

      t.timestamps
    end
    add_index :la_department_watcher_departments, :departmentid
    add_index :la_department_watcher_departments, :onlinestatus
    add_index :la_department_watcher_departments, :created_at
  end
end
