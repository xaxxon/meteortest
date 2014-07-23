

polls= new Meteor.Collection "polls"

options = new Meteor.Collection "options"

Router.map ->
	this.route 'create', path: '/'
	this.route 'results', path: '/results/:_id', data: -> results: options.find('poll_id': this.params._id)




if Meteor.isClient

	Template.show_poll_link.poll_id = ->
		Session.get "poll_id"
		

	Template.create.events
		'click #create_poll': -> 
			poll_id = polls.insert('name': $('#poll_name').val())
			options.insert('name': option_name, 'votes': 0, 'poll_id': poll_id) and console.log "added option " + option_name for option_name in ['a', 'b', 'c']
			Session.set "poll_id", poll_id
			console.log "Session poll id: " + Session.get "poll_id"
			console.log options.find().count()
		
	console.log "Done with client section"
	

if Meteor.isServer
	Meteor.startup = ->
		if  Players.find().count() == 0

	        Players.insert name: name
						   score: parseInt (Random.fraction()*10) *5 for name in ["Ada Lovelace"
                     "Grace Hopper"
                     "Marie Curie"
                     "Carl Friedrich Gauss"
                     "Nikola Tesla"
                     "Claude Shannon" ]
	    