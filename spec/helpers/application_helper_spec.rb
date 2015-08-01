require 'spec_helper'

describe ApplicationHelper do

   describe "translate scoped method" do

     describe ".scope_from_file_path" do
       it "returns the param formated as scope" do
         file_path = Rails.root.join('app', 'views', 'layouts', 'application.html.erb').to_s
         helper.scope_from_file_path(file_path).should == "views.layouts.application"
       end

       it "removes the initial underscore if present" do
         file_path = Rails.root.join('app', 'views', '_layouts', '_form.html.erb').to_s
         helper.scope_from_file_path(file_path).should == "views.layouts.form"
       end
     end

     describe ".ts" do
       it "calls scope_from_file_path method with file path" do
         Kernel.stub(:caller).and_return(['a', 'b', 'c'])
         helper.should_receive(:scope_from_file_path).with('a')
         helper.ts(:key)
       end

       it "calls translate method with key and scope based on file path" do
         helper.stub(:scope_from_file_path).and_return("views.layouts.application")
         I18n.should_receive(:translate).with(:key, scope: "views.layouts.application")
         helper.ts(:key)
       end
     end
   end

end
