require 'spec_helper'
module LaDepartmentWatcher
  describe 'Watcher' do

    before(:each) do
      @department_api = { "departmentid"=>"999-5d21e", "name"=>"Chat-Support-Team",
                          "description"=>"", "onlinestatus"=>"RTP",
                          "presetstatus"=>"RT", "deleted"=>"N" }
      @department = Department.find_by_department(@department_api)
      @yesterday = DateTime.now - 1
    end

    it 'should be ok' do
      department_api = @department
      expect(Watcher.notify(department_api, ['P','T'])).to be_nil
      expect(Watcher.notify(department_api, ['T'])).to be_nil
      expect(Watcher.notify(department_api, ['P'])).to be_nil
      expect(Watcher.notify(department_api, [])).to be_nil
    end

    it 'should start alert' do
      @department.onlinestatus = 'R'
      expect(LaDepartmentWatcher::Watcher.notify(@department, ['P','T'])).to eq(:start_alert)
    end

    it 'should send notify of alert' do
      @department.onlinestatus = 'R'
      expect(Watcher.notify(@department, ['P','T']))
        .to eq(:start_alert)
      alert = @department.last_alert
      alert.update_attribute('start_at', DateTime.now - 45.minutes)
      expect(Watcher.notify(@department, ['P','T']))
        .to eq(:notify)
    end

    it 'should close alert' do
      @department.onlinestatus = 'R'
      expect(Watcher.notify(@department, ['P','T']))
        .to eq(:start_alert)
      @department.onlinestatus = 'RT'
      expect(Watcher.notify(@department, ['P','T']))
        .to eq(:end_alert)
    end

    describe 'Notification per day' do
      before do
        @daily_alert = DailyOfflineAlert.new(notify_sent_at: @yesterday)
        @daily_alert.department = @department
      end

      it 'should sum offline minutes per day' do
        s = @yesterday.beginning_of_day
        @alerts = []
        @alerts << Alert.create(start_at: s + 0.minutes, end_at: s + 20.minutes, department_id: @department.id)
        s +=  20.minutes
        @alerts << Alert.create(start_at: s + 150.minutes, end_at: s + 210.minutes, department_id: @department.id)

        day_sum = DailyOfflineAlert.sum_offline_time(@alerts, s)
        day_sum.should eq (80 * 60)

        # start_of_day
        s = @yesterday.beginning_of_day
        @alerts << Alert.create(start_at: s - 20.minutes, end_at: s + 10.minutes, department_id: @department.id)
        day_sum = DailyOfflineAlert.sum_offline_time(@alerts, s)
        day_sum.should eq (90 * 60)
        @daily_alert.email_alert?.should be_false

        # end_of_day
        s = @yesterday.end_of_day
        @alerts << Alert.create(start_at: s - 20.minutes, end_at: s + 40.minutes, department_id: @department.id)
        day_sum = DailyOfflineAlert.sum_offline_time(@alerts, s)
        day_sum.should eq (110 * 60)

        @daily_alert.email_alert?.should be_true
      end


    end

  end
end