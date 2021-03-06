# frozen_string_literal: true

require 'scholarsphere/s3'

RSpec.describe Scholarsphere::S3::Uploader do
  let(:path) { fixture_path('image.png') }
  let(:uploader) { described_class.new(file: file) }

  describe '#upload', :vcr do
    subject(:upload) { uploader.upload }

    context 'with the default options' do
      let(:file) { Scholarsphere::S3::UploadedFile.new(source: path) }

      its(:status) { is_expected.to eq(200) }
    end

    context 'when providing a failing checksum' do
      let(:file) { Scholarsphere::S3::UploadedFile.new(source: path, checksum: 'xxx') }

      it 'raises an error' do
        expect {
          upload
        }.to raise_error(Scholarsphere::Client::Error)
      end
    end
  end
end
