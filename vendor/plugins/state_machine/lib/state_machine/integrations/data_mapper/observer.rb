module StateMachine
  module Integrations #:nodoc:
    module DataMapper
      # Adds support for creating before/after transition callbacks within a
      # DataMapper observer.  These callbacks behave very similarly to
      # before/after hooks during save/update/destroy/etc., but with the
      # following modifications:
      # * Each callback can define a set of transition conditions (i.e. guards)
      # that must be met in order for the callback to get invoked.
      # * An additional transition parameter is available that provides
      # contextual information about the event (see StateMachine::Transition
      # for more information)
      # 
      # To define a single observer for multiple state machines:
      # 
      #   class StateMachineObserver
      #     include DataMapper::Observer
      #     
      #     observe Vehicle, Switch, Project
      #     
      #     after_transition do |transition, saved|
      #       Audit.log(self, transition) if saved
      #     end
      #   end
      # 
      # == Requirements
      # 
      # To use this feature of the DataMapper integration, the dm-observer library
      # must be available.  This can be installed either directly or indirectly
      # through dm-more.  When loading DataMapper, be sure to load the dm-observer
      # library as well like so:
      # 
      #   require 'rubygems'
      #   require 'dm-core'
      #   require 'dm-observer'
      # 
      # If dm-observer is not available, then this feature will be skipped.
      # 
      module Observer
        include MatcherHelpers
        
        # Creates a callback that will be invoked *before* a transition is
        # performed, so long as the given configuration options match the
        # transition.  Each part of the transition (event, to state, from state)
        # must match in order for the callback to get invoked.
        # 
        # See StateMachine::Machine#before_transition for more
        # information about the various configuration options available.
        # 
        # == Examples
        # 
        #   class Vehicle
        #     include DataMapper::Resource
        #     
        #     property :id, Serial
        #     property :state, :String
        #     
        #     state_machine :initial => :parked do
        #       event :ignite do
        #         transition :parked => :idling
        #       end
        #     end
        #   end
        #   
        #   class VehicleObserver
        #     include DataMapper::Observer
        #     
        #     observe Vehicle
        #     
        #     before :save do
        #       # log message
        #     end
        #     
        #     # Target all state machines
        #     before_transition :parked => :idling, :on => :ignite do
        #       # put on seatbelt
        #     end
        #     
        #     # Target a specific state machine
        #     before_transition :state, any => :idling do
        #       # put on seatbelt
        #     end
        #     
        #     # Target all state machines without requirements
        #     before_transition do |transition|
        #       # log message
        #     end
        #   end
        # 
        # *Note* that in each of the above +before_transition+ callbacks, the
        # callback is executed within the context of the object (i.e. the
        # Vehicle instance being transition).  This means that +self+ refers
        # to the vehicle record within each callback block.
        def before_transition(*args, &block)
          add_transition_callback(:before, *args, &block)
        end
        
        # Creates a callback that will be invoked *after* a transition is
        # performed, so long as the given configuration options match the
        # transition.  Each part of the transition (event, to state, from state)
        # must match in order for the callback to get invoked.
        # 
        # See StateMachine::Machine#after_transition for more
        # information about the various configuration options available.
        # 
        # == Examples
        # 
        #   class Vehicle
        #     include DataMapper::Resource
        #     
        #     property :id, Serial
        #     property :state, :String
        #     
        #     state_machine :initial => :parked do
        #       event :ignite do
        #         transition :parked => :idling
        #       end
        #     end
        #   end
        #   
        #   class VehicleObserver
        #     include DataMapper::Observer
        #     
        #     observe Vehicle
        #     
        #     after :save do |saved|
        #       # log message
        #     end
        #     
        #     # Target all state machines
        #     after_transition :parked => :idling, :on => :ignite do
        #       # put on seatbelt
        #     end
        #     
        #     # Target a specific state machine
        #     after_transition :state, any => :idling do
        #       # put on seatbelt
        #     end
        #     
        #     # Target all state machines without requirements
        #     after_transition do |transition, saved|
        #       if saved
        #         # log message
        #       end
        #     end
        #   end
        # 
        # *Note* that in each of the above +before_transition+ callbacks, the
        # callback is executed within the context of the object (i.e. the
        # Vehicle instance being transition).  This means that +self+ refers
        # to the vehicle record within each callback block.
        def after_transition(*args, &block)
          add_transition_callback(:after, *args, &block)
        end
        
        private
          # Adds the transition callback to a specific machine or all of the
          # state machines for each observed class.
          def add_transition_callback(type, *args, &block)
            if args.first && !args.first.is_a?(Hash)
              # Specific attribute is being targeted
              attribute = args.first
              transition_args = args[1..-1]
            else
              # Target all state machines
              attribute = nil
              transition_args = args
            end
            
            # Add the transition callback to each class being observed
            observing.each do |klass|
              state_machines = attribute ? [klass.state_machine(attribute)] : klass.state_machines.values
              state_machines.each {|machine| machine.send("#{type}_transition", *transition_args, &block)}
            end if observing
          end
      end
    end
  end
end

DataMapper::Observer::ClassMethods.class_eval do
  include StateMachine::Integrations::DataMapper::Observer
end
