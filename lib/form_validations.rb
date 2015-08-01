module ActiveRecord
  module Validations
    module ClassMethods
 
      def validates_email_format(value)
        validates_format_of value,
                            :with => /\A[\w\._%-]+@[\w\.-]+\.[a-zA-Z]{2,4}\z/,
                            :if => Proc.new { |u| !u.email.nil? && !u.email.blank? },
                            :message => "Insira um email válido"
      end

      def validates_alfanumerico_format(value)
        validates_format_of value,
                            :with => /[a-zA-Z0-9]/,
                            :if => Proc.new { |u| !u.email.nil? && !u.email.blank? },
                            :message => "Não use símbolos"
      end

    end
  end
end