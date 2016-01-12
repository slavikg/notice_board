class Ability
	include CanCan::Ability

	def initialize(user)
		alias_action :update, :destroy, to: :modify
		# Define abilities for the passed in user here. For example:
		#
		user ||= User.new role: "guest" # guest user (not logged in)
		if user.role? :guest
			can :read, [User, Advert]
			can :create, User
			# can :show, User
		else
			if user.role? :admin
				can :manage, :all
				# can :update_user_role, User
			else
				if user.role? :moderator
					can :manage, [Advert, Comment]
					can :read, User
					can :update, User do |can_user|
						can_user == user
					end
					# cannot :update_user_role, User
				else
					can :read, User
					can :update, User do |can_user|
						can_user == user
					end
					# cannot :update_user_role, User
					can [:read, :create], [Advert, Comment]
					can :modify, [Advert, Comment] do |element|
						element.user == user
					end
				end
			end
		end
		#
		# The first argument to `can` is the action you are giving the user
		# permission to do.
		# If you pass :manage it will apply to every action. Other common actions
		# here are :read, :create, :update and :destroy.
		#
		# The second argument is the resource the user can perform the action on.
		# If you pass :all it will apply to every resource. Otherwise pass a Ruby
		# class of the resource.
		#
		# The third argument is an optional hash of conditions to further filter the
		# objects.
		# For example, here the user can only update published articles.
		#
		#   can :update, Article, :published => true
		#
		# See the wiki for details:
		# https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
	end
end
