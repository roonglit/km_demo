module AnalyzerLifeCycle
  extend ActiveSupport::Concern

  included do
    define_model_callbacks :file_analyzed

    class_attribute :after_file_analyzed_callbacks
    self.after_file_analyzed_callbacks = []

    def self.after_file_analyzed(method)
      self.after_file_analyzed_callbacks += [method]
    end
  end

  def run_file_analyzed_callbacks(metadata)
    run_callbacks :file_analyzed do
      self.class.after_file_analyzed_callbacks.each do |callback|
        send(callback, metadata)
      end
    end
  end
end