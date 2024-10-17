# frozen_string_literal: true

module ActiveStorage
  class BlobsController < ApplicationController
    skip_before_action :verify_authenticity_token, only: :pdf_callback

    before_action :set_blob

    def pdf_callback
      updated_metadata = @blob.metadata.except(:require_ocr)
      updated_metadata.merge!(text: params[:extracted_text])

      @blob.update! metadata: updated_metadata

      @blob.attachments.includes(:record).each do |attachment|
        record = attachment.record
        if record.respond_to?(:run_file_analyzed_callbacks)
          record.run_file_analyzed_callbacks(@blob.metadata)
        end
      end

      head :ok
    end

    private

    def set_blob
      @blob = ActiveStorage::Blob.find(params[:id])
    end
  end
end
