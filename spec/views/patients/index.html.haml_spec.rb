require 'rails_helper'

RSpec.describe "patients/index", type: :view do
  before(:each) do
    assign(:patients, [
      Patient.create!(
        :firstName => "First Name",
        :lastName => "Last Name",
        :pesel => "Pesel",
        :address => "Address"
      ),
      Patient.create!(
        :firstName => "First Name",
        :lastName => "Last Name",
        :pesel => "Pesel",
        :address => "Address"
      )
    ])
  end

  it "renders a list of patients" do
    render
    assert_select "tr>td", :text => "First Name".to_s, :count => 2
    assert_select "tr>td", :text => "Last Name".to_s, :count => 2
    assert_select "tr>td", :text => "Pesel".to_s, :count => 2
    assert_select "tr>td", :text => "Address".to_s, :count => 2
  end
end
