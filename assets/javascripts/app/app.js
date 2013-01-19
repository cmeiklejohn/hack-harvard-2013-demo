App = Ember.Application.create();

App.Store = DS.Store.extend({
  revision: 11
});

App.Router.map(function() {
  this.resource('projects', function() {
    this.route('show', { path: '/:project_id' });
  });
});

App.Project = DS.Model.extend({
  name: DS.attr('string'),
  desc: DS.attr('string'),
  votes: DS.attr('number')
});

/** Default route */

App.IndexRoute = Ember.Route.extend({
  redirect: function() {
    this.transitionTo('projects');
  }
});

/** Projects */

App.ProjectsController = Ember.ArrayController.extend();

App.ProjectsRoute = Ember.Route.extend({
  model: function() {
    return App.Project.find();
  },

  setupController: function(controller, projects) {
    controller.set('content', projects);
  },

  renderTemplate: function() {
    this.render('projects');
  }
});

/** Project */

App.ProjectsShowController = Ember.ObjectController.extend({
  vote: function() {
    var project = this.get('content');
    project.set('votes', this.get('votes') + 1);
  }
});

App.ProjectsShowRoute = Ember.Route.extend({
  model: function(params) {
    return App.Project.find(params.project_id);
  },

  setupController: function(controller, project) {
    controller.set('content', project);
  },

  renderTemplate: function() {
    this.render('project', { outlet: 'project' });
  }
});

minispade.require('templates');
