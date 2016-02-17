# Collection of Custom Exception
module CustomException
  class Unauthorized < StandardError
    def message
      I18n.t('exception.unauthorized')
    end
  end

  class RequestTimeOut < StandardError
    def message
      I18n.t('exception.request_time_out')
    end
  end

  class DomainConflict < StandardError
    def message
      I18n.t('exception.domain_conflict')
    end
  end
end
