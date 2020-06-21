# frozen_string_literal: true

require 'spec_helper'

describe 'manifest_whitespace_two_empty_lines' do
  let(:single_space_msg) { 'there should be no two consecutive empty lines' }

  context 'with two spaces' do
    let(:code) do
      <<~EOF
        class { 'example2':
          param1 => 'value1',


          param2 => 'value2',
        }
      EOF
    end

    context 'with fix disabled' do
      it 'should detect a single problem' do
        expect(problems).to have(1).problem
      end

      it 'should create a error' do
        expect(problems).to contain_error(single_space_msg).on_line(4).in_column(1)
      end
    end

    context 'with fix enabled' do
      before do
        PuppetLint.configuration.fix = true
      end

      after do
        PuppetLint.configuration.fix = false
      end

      it 'should detect a single problem' do
        expect(problems).to have(1).problem
      end

      it 'should fix the manifest' do
        expect(problems).to contain_fixed(single_space_msg)
      end

      it 'should fix the space' do
        expect(manifest).to eq(
          <<~EOF,
            class { 'example2':
              param1 => 'value1',

              param2 => 'value2',
            }
          EOF
        )
      end
    end
  end
end
