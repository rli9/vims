require 'net/http'
require 'uri'

class InputTestResult

	def initialize(uri, local_result_path, result_type, build_name, account)
		@local_result_path = local_result_path
		@result_type = result_type
		@build_name = build_name
		@uri = URI.parse(uri)
		@http = Net::HTTP.new(@uri.host, @uri.port)
		@cookie = http_cookie('/login', account)
	end

	def http_post_paras(path, paras)
		request = Net::HTTP::Post.new(path)
		request['Cookie'] = @cookie
		request.set_form_data(paras)
		response = @http.request(request)
		if response.code == "200" || response.code == "302"
			return true
		else
			return false
		end
	end

	def http_cookie(path, paras)
		cookie = nil
		request = Net::HTTP::Post.new(path)
		request.set_form_data(paras)
		response = @http.request(request)
		cookie = response.response['set-cookie'] if response.code == "200" || response.code == "302"
		cookie
	end

	def lbt_test_results(local_result_path)
		diries = Dir.entries(local_result_path).select {|entry| File.basename(entry)[0] != ?.}.reject {|file_name| file_name.include?('.')}.collect {|item| local_result_path + '/' + item}
		fail_file = Dir.entries(diries[0]).select {|file_name| file_name.include?("ReportFail")}[0]
		pass_file = Dir.entries(diries[0]).select {|file_name| file_name.include?("ReportPass")}[0]
		@results = Hash.new
		['fail', 'pass'].each {|item| @results[item] = []}
		test_results = Hash.new
		if !fail_file.nil?
			fail_results = File.readlines(diries[0] + '/' + fail_file)
			pass_results = File.readlines(diries[0] + '/' + pass_file)
		end

		fail_results.compact.uniq.each do |item|
			item = item.gsub(/Qxcm_jit_target = gen\d(_\d)?/, "Qxcm_jit_target = genX") if item.include?("Qxcm_jit_target = gen")
			item = 'VsBuild_' + item if item.include?("_debug_win") || item.include?("_release_win")
			@results['fail'] << item.strip.chomp
		end
		pass_results.compact.uniq.each do |item|
			item = item.gsub(/Qxcm_jit_target = gen\d(_\d)?/, "Qxcm_jit_target = genX") if item.include?("Qxcm_jit_target = gen")
			item = 'VsBuild_' + item if item.include?("_debug_win") || item.include?("_release_win")
			@results['pass'] << item.strip.chomp
		end
		test_results['pass'] = @results['pass'].join("\r\n")
		test_results['fail'] = @results['fail'].join("\r\n")
		test_results
	end

	def other_test_results(local_result_path)
		fail_file = Dir.entries(local_result_path).select {|file_name| file_name.include?("_fail.txt")}[0]
		pass_file = Dir.entries(local_result_path).select {|file_name| file_name.include?("_pass.txt")}[0]

		@results = Hash.new
		['fail', 'pass'].each {|item| @results[item] = []}
		test_results = Hash.new
		if !fail_file.nil?
			@results['fail'] = File.readlines(local_result_path + '/' + fail_file).reject {|item| item.include?("#fail")}
			@results['pass'] = File.readlines(local_result_path + '/' + pass_file).reject {|item| item.include?("#pass")}
		end

		test_results['pass'] = @results['pass'].collect {|item| item.chomp}.join("\r\n")
		test_results['fail'] = @results['fail'].collect {|item| item.chomp}.join("\r\n")
		test_results
	end

	def input_result
		project = http_post_paras("/projects/manage", {"id" => 19}) if !@cookie.nil?
		test_results = lbt_test_results(@local_result_path) if @result_type == 'lbt'
		test_results = other_test_results(@local_result_path) if @result_type == 'other'
		puts "input pass #{@results['pass'].size} results:"
		pass_results_paras = {"test_target_instance_name" => @build_name, "test_case_names" => test_results['pass'], 'test_results[test_target_pass]' => 1, 'test_results[test_target_fail]' => 0, 'test_results[test_case_fail]' => 0}
		pass = http_post_paras("/test_target_instances/create_test_results_by_test_case_names", pass_results_paras) if project

		puts "input fail #{@results['fail'].size} results:"
		fail_results_paras = {"test_target_instance_name" => @build_name, "test_case_names" => test_results['fail'], 'test_results[test_target_pass]' => 0, 'test_results[test_target_fail]' => 1, 'test_results[test_case_fail]' => 0}
		fail = http_post_paras("/test_target_instances/create_test_results_by_test_case_names", fail_results_paras) if pass
		puts "Input finished"
	end
end


local_result_path = "#{ARGV[0]}"
result_type = "#{ARGV[1]}"
build_name = "Win_" + ARGV[2]
uri = "http://shwde8255"

account = {"member[name]" => 'Yin, Ling LingX', "member[password]" => '123456'}

input_test_result = InputTestResult.new(uri, local_result_path, result_type, build_name, account)
input_test_result.input_result

