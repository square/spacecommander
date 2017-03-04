#!/usr/bin/env ruby

def check_oclint
	workspace = ARGV[0]
	scheme = ARGV[1]
	changed_files_args = ARGV.drop(2)
	changed_file_string = changed_files_args.join("\n")

	puts "\n###############################################\n"
	puts "\n#### OCLint                                ####\n"
	puts "\n###############################################\n"

	puts "\nChecking:\n"
	puts "\n#{changed_file_string}\n"
	changed_files = changed_file_string.split("\n")
	
	file_filter_arguments = []
	changed_files.each do |changed_file_string|
		file_filter_arguments.push("-i #{changed_file_string}")
	end

	if (!file_filter_arguments.empty?)
		compilation_db_file_filter_argument = file_filter_arguments.join(" ")
		oclint_analyze(workspace, scheme, compilation_db_file_filter_argument)
	end

    puts "\n#### Done ####\n"
end

def oclint_analyze(workspace, scheme, file_filter_argument)
	puts "\nRunning OCLint Analysis. This may take a while...\n"
	system_raise_failure("export LC_ALL=en_US.UTF-8 && xcodebuild CODE_SIGN_IDENTITY=\"\" CODE_SIGNING_REQUIRED=NO" +
		" -workspace \"#{workspace}\" -scheme \"#{scheme}\" -configuration 'Debug' -sdk iphoneos clean build -dry-run" + 
		" | xcpretty -t --report json-compilation-database --output compile_commands.json")

	system_raise_failure("oclint-json-compilation-database #{file_filter_argument} --" + 
		" -list-enabled-rules -report-type=text")
end

def check_space_commander
	puts "\n###############################################\n"
	puts "\n#### SpaceCommander                        ####\n"
	puts "\n###############################################\n"
	system_raise_failure("set -e && ./Pods/SpaceCommander/format-objc-mobuild #{ENV['MASTER_COMMIT_HASH']}")
end

def system_raise_failure(command)
    system("set -o pipefail && #{command}")
    exit_status = "#{$?.exitstatus}"

    if (exit_status != "0")
        exit(exit_status.to_i)
    end
end

if (!(ENV['SKIP_SPACECOMMANDER'] == "YES"))
	check_space_commander
end

check_oclint
