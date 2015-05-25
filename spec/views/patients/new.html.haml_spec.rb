require 'rails_helper'

RSpec.describe "patients/new", type: :view do
  before(:each) do
    assign(:patient, Patient.new(
      :firstName => "MyString",
      :lastName => "MyString",
      :pesel => "MyString",
      :address => "MyString"
    ))
  end

  it "renders new patient form" do
    render

    assert_select "form[action=?][method=?]", patients_path, "post" do

      assert_select "input#patient_firstName[name=?]", "patient[firstName]"

      assert_select "input#patient_lastName[name=?]", "patient[lastName]"

      assert_select "input#patient_pesel[name=?]", "patient[pesel]"

      assert_select "input#patient_address[name=?]", "patient[address]"
    end
  end
end
