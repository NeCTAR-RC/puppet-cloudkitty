require 'spec_helper'

describe 'cloudkitty::db::mysql' do

  let :pre_condition do
    'include mysql::server'
  end

  let :required_params do
    { :password => 'cloudkittypass', }
  end

  shared_examples_for 'cloudkitty-db-mysql' do
    context 'with only required params' do
      let :params do
        required_params
      end

      it { is_expected.to contain_class('cloudkitty::deps') }

      it { is_expected.to contain_openstacklib__db__mysql('cloudkitty').with(
        :user     => 'cloudkitty',
        :password => 'cloudkittypass',
        :dbname   => 'cloudkitty',
        :host     => '127.0.0.1',
        :charset  => 'utf8',
        :collate  => 'utf8_general_ci',
      )}
    end

    context 'overriding allowed_hosts param to array' do
      let :params do
        { :allowed_hosts => ['127.0.0.1','%'] }.merge(required_params)
      end

      it { is_expected.to contain_openstacklib__db__mysql('cloudkitty').with(
        :user          => 'cloudkitty',
        :password      => 'cloudkittypass',
        :dbname        => 'cloudkitty',
        :host          => '127.0.0.1',
        :charset       => 'utf8',
        :collate       => 'utf8_general_ci',
        :allowed_hosts => ['127.0.0.1','%']
      )}
    end

    describe 'overriding allowed_hosts param to string' do
      let :params do
        { :allowed_hosts => '192.168.1.1' }.merge(required_params)
      end

      it { is_expected.to contain_openstacklib__db__mysql('cloudkitty').with(
        :user          => 'cloudkitty',
        :password      => 'cloudkittypass',
        :dbname        => 'cloudkitty',
        :host          => '127.0.0.1',
        :charset       => 'utf8',
        :collate       => 'utf8_general_ci',
        :allowed_hosts => '192.168.1.1'
      )}
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'cloudkitty-db-mysql'
    end
  end
end
