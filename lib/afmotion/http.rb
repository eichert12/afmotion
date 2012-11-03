module AFMotion
  module HTTPBuilder
    def self.included(base)
      AFMotion::HTTP_METHODS.each do |method|
        base.send(:define_singleton_method, method, -> (url, parameters = {}, &callback) do
          request = NSMutableURLRequest.requestWithURL(url.to_url)
          request.HTTPMethod = method.upcase

          operation = (self.request_module.for_request(request) do |result|
            callback.call(result)
          end)

          operation.start
          operation
        end)
      end
    end
  end

  module HTTP
    include AFMotion::HTTPBuilder

    module_function
    def request_module
      AFMotion::Operation::HTTP
    end
  end

  module JSON
    include AFMotion::HTTPBuilder

    module_function
    def request_module
      AFMotion::Operation::JSON
    end
  end

  module XML
    include AFMotion::HTTPBuilder

    module_function
    def request_module
      AFMotion::Operation::XML
    end
  end

  module PLIST
    include AFMotion::HTTPBuilder

    module_function
    def request_module
      AFMotion::Operation::PLIST
    end
  end
end