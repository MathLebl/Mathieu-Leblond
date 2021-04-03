class ApplicationService
  private_methods :new

  class << self
    def call(*args)
      new(*args).call
    end

    def async_call(*args)
      ServiceInvocationJob.perform_later(self.to_s, args)
    end
  end
end
