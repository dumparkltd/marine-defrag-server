class ActorTypeSerializer
  include FastApplicationSerializer

  attributes(
    :has_members,
    :is_active,
    :is_target,
    :title
  )

  set_type :actor_types
end
