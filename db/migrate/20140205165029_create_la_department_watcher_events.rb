class CreateLaDepartmentWatcherEvents < ActiveRecord::Migration
  def change
    create_table :la_department_watcher_events do |t|
      t.string :type
      t.datetime :start_at
      t.datetime :end_at
      t.text :text_description
      t.datetime :notify_sent_at
      t.string :notify_sent_to
      t.text :agents_statuses_json

      t.timestamps
    end
  end
end
