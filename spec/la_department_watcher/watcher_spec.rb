require 'spec_helper'
module LaDepartmentWatcher
  describe 'Watcher' do

    before(:each) do
      @department_api = { "departmentid"=>"5965d21e", "name"=>"Chat-Support-Team",
                          "description"=>"", "onlinestatus"=>"RTP",
                          "presetstatus"=>"RT", "deleted"=>"N" }
      @department = Department.find_by_department(@department_api)
    end

    it 'should be ok' do
      department_api = @department_api
      expect(Watcher.save_and_notify(department_api, ['P','T'])).to be_nil
      expect(Watcher.save_and_notify(department_api, ['T'])).to be_nil
      expect(Watcher.save_and_notify(department_api, ['P'])).to be_nil
      expect(Watcher.save_and_notify(department_api, [])).to be_nil
    end

    it 'should start alert' do
      @department_api['onlinestatus'] = 'R'
      expect(LaDepartmentWatcher::Watcher.save_and_notify(@department_api, ['P','T'])).to eq(:start_alert)
    end

    it 'should send notify of alert' do
      @department_api['onlinestatus'] = 'R'
      expect(Watcher.save_and_notify(@department_api, ['P','T']))
        .to eq(:start_alert)
      alert = @department.last_alert
      alert.update_attribute('start_at', DateTime.now - 45.minutes)
      expect(Watcher.save_and_notify(@department_api, ['P','T']))
        .to eq(:notify)
    end

    it 'should close alert' do
      @department_api['onlinestatus'] = 'R'
      expect(Watcher.save_and_notify(@department_api, ['P','T']))
        .to eq(:start_alert)
      @department_api['onlinestatus'] = 'RT'
      expect(Watcher.save_and_notify(@department_api, ['P','T']))
        .to eq(:end_alert)
    end
  end
end