expand!

default[:biodivUi][:version]   = "master"
default[:biodivUi][:appname]   = "biodiv-ui"
default[:biodivUi][:repository]   = "biodiv-ui"
default[:biodivUi][:directory] = "/usr/local/src"

default[:biodivUi][:link]      = "https://codeload.github.com/strandls/#{biodivUi.repository}/zip/#{biodivUi.version}"
default[:biodivUi][:extracted] = "#{biodivUi.directory}/#{biodivUi.appname}-#{biodivUi.version}"
#default[:biodivUi][:war]       = "#{biodivUi.extracted}/build/libs/#{biodivUi.appname}.war"
default[:biodivUi][:download]  = "#{biodivUi.directory}/#{biodivUi.repository}-#{biodivUi.version}.zip"

default[:biodivUi][:home] = "/usr/local/biodiv-ui"

