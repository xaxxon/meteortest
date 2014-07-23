

random_color =  -> "rgb(" +  Math.floor(Math.random() * 255) + "," + Math.floor(Math.random() * 255) + "," + Math.floor(Math.random() * 255)+")"


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
	
