{print} = require "sys"
{spawn, exec} = require "child_process"

paths =
	coffee:
		spec: "coffee/lib/ coffee/spec/"
		app: "coffee/lib/ coffee/app.coffee"
	js: "js/"

run = (command) ->
	exec command, (err, stdout, stderr) ->
		throw err if err
		console.log stdout + stderr if stdout or stderr

clean = (dst) ->
	command = "rm -R #{dst}"
	run command

task "clean", "Remove build output directory", ->
	clean paths.js

task "build", "Build all coffee to js", ->
	for group, sources of paths.coffee
		run "coffee --compile --output #{paths.js} --join #{group} #{sources}"

task "buildw:app", "Build and watch app coffee to js", ->
	run "coffee --watch --compile --output #{paths.js} --join app #{paths.coffee.app}"

task "buildw:spec", "Build and watch spec coffee to js", ->
	run "coffee --watch --compile --output #{paths.js} --join spec #{paths.coffee.spec}"
