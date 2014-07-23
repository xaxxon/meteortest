
Players = new Meteor.Collection "players"

draw_chart = ->
	console.log "In draw_chart"
	mycanvas = $("#mycanvas")[0]
	
	# Error checking to make sure the canvas exists when this is called
	unless mycanvas
		console.log "Couldn't find canvas"
		return
		
	
	# data = a: Math.random(), b: Math.random(), c: Math.random(), d: Math.random()
	
	console.log mycanvas
	if mycanvas.getContext
		height = mycanvas.height
		width = mycanvas.width
		
		ctx = mycanvas.getContext "2d"

		# ctx.fillStyle = "rgb(200,0,0)"
		# ctx.fillRect 10, 10, 55, 50
		#
		# ctx.fillStyle = "rgba(0, 0, 200, 0.5)"
		# ctx.fillRect 30, 30,  55, 50
		
		console.log "Fetch results"
		console.log Players.find({}).fetch()
		
		console.log "iterating over fetch results"
		console.log player for player in Players.find({}).fetch()
		data = {}
		
		for player in Players.find({}).fetch() when player['name']
			data[player['name']] = parseInt(player['score']) 
			console.log "Adding player to data"
		console.log "Data hash"
		console.log data
		
		total_score = (score for nil, score of data).reduce (x,y) -> x+y
		score_so_far = 0

		min_dimension = if height > width then width else height
		radius = min_dimension * .45
		center_x = width / 2
		center_y = height / 2
		
		TAU = Math.PI * 2
		
		for name, score of data

			start_x = Math.cos(TAU * score_so_far / total_score) * radius + center_x
			start_y = Math.sin(TAU * score_so_far / total_score) * radius + center_y
			end_x = Math.cos(TAU * (score_so_far + score) / total_score) * radius + center_x
			end_y = Math.sin(TAU * (score_so_far + score) / total_score) * radius + center_y
			

			ctx.beginPath()
			ctx.moveTo center_x, center_y
			ctx.lineTo start_x, start_y
			
			ctx.arc center_x, center_y, radius, TAU * score_so_far / total_score, TAU * (score_so_far + score) / total_score
			ctx.strokeStyle = random_color()
			ctx.fillStyle = random_color()
			
			# ctx.moveTo center_x, center_y
			ctx.lineTo center_x, center_y
			ctx.closePath()
			# ctx.stroke()
			ctx.fill()
			
			
							
			score_so_far += score

		
	else
		console.log "no canvas"
	

if Meteor.isClient

	Session.setDefault("sort", "name")
	Session.set("sort", "name") if jQuery("#sort_checkbox").is(":checked") 

	random_color =  -> "rgb(" +  Math.floor(Math.random() * 255) + "," + Math.floor(Math.random() * 255) + "," + Math.floor(Math.random() * 255)+")"


	$ ->


		
	Template.leaderboard.players = ->
		if Session.equals("sort", "name" )
			console.log "sort by name"
			Players.find({}, {sort: ["name", "score"]})
		else
			console.log "sort by score"
			Players.find({}, {sort: ["score", "name"]})

	
	Template.leaderboard.rendered = ->
		console.log "trying to observe changes"
		Players.find({}).observe changed: draw_chart, removed: draw_chart


	Template.leaderboard.selected_name = ->
		player = Players.findOne(Session.get("selected_player"))
		return player && player.name


	Template.player.selected = ->
		if Session.equals("selected_player", this._id) then "selected" else ''


	Template.leaderboard.events 
		'click input.inc': -> Players.update Session.get("selected_player"), {$inc: {score: 5}}
		'click input#sort_checkbox': -> Session.set("sort", if jQuery("#sort_checkbox").is(':checked') then "name" else "score")
		'submit form#add_player_form': (event)-> 
			textbox = $("#add_player")
			Players.insert name: textbox.val(), score: 0
			textbox.val("")
			event.preventDefault()
	
									

	Template.player.events 
		'click': ->
			Session.set("selected_player", this._id)
		'click .delete': 
			(event) -> 
				Players.remove(this._id)
		
	console.log "Done with client section"
	

if Meteor.isServer
	Meteor.startup = ->
		if  Players.find().count() == 0
			names = ["Ada Lovelace"
                     "Grace Hopper"
                     "Marie Curie"
                     "Carl Friedrich Gauss"
                     "Nikola Tesla"
                     "Claude Shannon" ]

		for name in names
	        Players.insert name: names[i]
						   score: parseInt (Random.fraction()*10) *5
	    