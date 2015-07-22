module SchedulesHelper
  def gen_weekday_list
    weekday = Struct.new(:id, :name)
    @weekday_list = [weekday.new(1, 'Monday'), 
      weekday.new(2, 'Tuesday'), 
      weekday.new(3, 'Wednesday'), 
      weekday.new(4, 'Thursday'), 
      weekday.new(5, 'Friday')]
  end
end
