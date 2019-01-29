# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Jekyll::GitHubMetadata::Owner) do
  subject { described_class.new(login) }
  before(:each) do
    ENV["JEKYLL_GITHUB_TOKEN"] = "allthespecs"
  end

  context "is an ORG" do
    let(:login) { "jekyll" }
    let!(:stub) do
      stub_api("/orgs/#{login}", "org")
    end

    EXPECTED_ATTRIBUTES_ORG = {
      :login                     => "jekyll",
      :id                        => 3_083_652,
      :node_id                   => "MDEyOk9yZ2FuaXphdGlvbjMwODM2NTI=",
      :avatar_url                => "https://avatars0.githubusercontent.com/u/3083652?v=4",
      :description               => "Jekyll is a blog-aware, static site generator in Ruby.",
      :name                      => "Jekyll",
      :company                   => nil,
      :blog                      => "https://jekyllrb.com",
      :location                  => nil,
      :email                     => "",
      :is_verified               => true,
      :has_organization_projects => true,
      :has_repository_projects   => true,
      :public_repos              => 50,
      :public_gists              => 0,
      :followers                 => 0,
      :following                 => 0,
      :html_url                  => "https://github.com/jekyll",
      :created_at                => Time.parse("2012-12-19 19:37:35 UTC"),
      :updated_at                => Time.parse("2019-01-27 15:27:32 UTC"),
      :type                      => "Organization",
    }.freeze

    EXPECTED_ATTRIBUTES_ORG.each do |attribute, expected_value|
      it "fetches #{attribute}" do
        expect(subject.public_send(attribute)).to eq(expected_value)
      end
    end

    it "blocks denied attributes" do
      expect(subject).not_to respond_to(:repos_url)
    end
  end

  context "is a USER" do
    let(:login) { "jekyllbot" }
    let!(:stub) do
      stub_api_404("/orgs/#{login}")
      stub_api("/users/#{login}", "user")
    end

    EXPECTED_ATTRIBUTES_USER = {
      :login        => "jekyllbot",
      :id           => 6_166_343,
      :node_id      => "MDQ6VXNlcjYxNjYzNDM=",
      :avatar_url   => "https://avatars0.githubusercontent.com/u/6166343?v=4",
      :type         => "User",
      :name         => "jekyllbot",
      :company      => nil,
      :blog         => "https://github.com/parkr/auto-reply",
      :location     => nil,
      :email        => nil,
      :hireable     => nil,
      :bio          => "I help make working with @jekyll fun and easy.",
      :public_repos => 2,
      :public_gists => 0,
      :followers    => 68,
      :following    => 0,
      :created_at   => Time.parse("2013-12-12 02:49:00 UTC"),
      :updated_at   => Time.parse("2017-12-05 21:23:41 UTC"),
    }.freeze

    EXPECTED_ATTRIBUTES_USER.each do |attribute, expected_value|
      it "fetches #{attribute}" do
        expect(subject.public_send(attribute)).to eq(expected_value)
      end
    end

    it "blocks denied attributes" do
      expect(subject).not_to respond_to(:site_admin)
      expect(subject).not_to respond_to(:repos_url)
    end
  end
end
