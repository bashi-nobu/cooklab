class DateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    value = record.send("#{attribute}_before_type_cast")
    begin
      if value.present?
        check_date = value[1].to_s+'/'+value[2].to_s+'/'+value[3].to_s
        Date.parse check_date
      end
    rescue ArgumentError
      record.errors[attribute] << I18n.t('errors.messages.invalid')
    end
  end
end
