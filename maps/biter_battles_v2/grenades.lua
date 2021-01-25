
local Event = require 'utils.event'
local pic = require "maps.biter_battles_v2.pictures"
local list=nil
local list_tail=nil
local list_position
local list_index
local function sqr(x)
	return x*x
end
local function on_player_used_capsule(event)
	if event.item.name=="grenade" then
	
		local node={next=list,
		req_tick=game.tick+60*math.sqrt(sqr(game.players[event.player_index].position.x- event.position.x)+sqr(game.players[event.player_index].position.y- event.position.y))/22.91,
		position=event.position,
		index=event.player_index
		}
		if list_tail==nil then
			list_tail=node
		else
			list_tail.next=node
		end
		if list==nil then
			list=node
		end
	end
end
local radius = 3
local function on_tick2()

	local damage = 30
	
	if list~=nil then
		if(not global.bb_game_won_by_team)then
			while game.tick >=list.req_tick do 
				for _, e in pairs(
					game.players[list.index].surface.find_entities_filtered(
						{area = {{list.position.x - radius, list.position.y - radius}, {list.position.x + radius, list.position.y + radius}}}
					)
				) do
					if e.valid and e.health then
						local distance_from_center = math.sqrt((e.position.x - list.position.x) ^ 2 + (e.position.y - list.position.y) ^ 2)
						if distance_from_center <= radius then
							e.damage(damage, 'player', 'explosion')
						end
					end
				end
				list=list.next
			end
		else
			while game.tick >=list.req_tick do 
				for i,v in ipairs(pic[math.random(1, 5)]) do game.players[list.index].surface.create_entity({name = 'fire-flame', position = {list.position.x+v[1],list.position.y+v[2]}})
				end
				list=list.next
			end
		end
	end
end
Event.add(defines.events.on_player_used_capsule, on_player_used_capsule)
Event.add(defines.events.on_tick, on_tick2)
