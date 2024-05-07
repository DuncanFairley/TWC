
mob
	Enemies
		Summoned
			state = SEARCH
			MapInit()
				set waitfor = 0
				calcStats()
				state()

			ShouldIBeActive()
				if(!loc)
					state = INACTIVE
					return 0

				ChangeState(SEARCH)
				return 1

			ReturnToStart()
				ShouldIBeActive()

			Slug
				icon_state = "slug"

				MapInit()
					set waitfor = 0
					walk_rand(src,15)

					sleep(100)
					walk(src, 0)
					loc = null
				BlindAttack()
				Death()

			Sword
				icon = 'Mobs_128x128.dmi'
				icon_state = "sword"
				iconSize = 4
				pixel_x = -48
				pixel_y = -24
				name = "Flying Sword"
				level = 800
				MoveDelay = 2
				AttackDelay = 5
				Range = 20
				HPmodifier = 4
				canBleed = FALSE
				var/tmp/obj/Shadow/s

				Death()
					if(s)
						s.loc = null
						s = null

					var/RandomEvent/Sword/e = locate() in worldData.currentEvents
					if(e)
						e.swords--
				Dispose()
					..()

					if(s)
						s.loc = null
						s = null

				MapInit()
					set waitfor = 0
					..()

					var/size = rand(10,30) / 10
					SetSize(size)

					s = new (loc)
					s.transform = matrix() * size

					animate(src, pixel_y = 0, time = 2, loop = -1)
					animate(pixel_y = 1, time = 2)
					animate(pixel_y = 0, time = 2)
					animate(pixel_y = -1, time = 2)


				Move(newLoc)
					if(s)
						s.glide_size = glide_size
						s.loc = newLoc
					..()

			Acromantula
				icon = 'Mobs.dmi'
				name = "Tiny Spider"
				icon_state = "spider"
				level = 700
				MoveDelay = 2
				AttackDelay = 5
				Range = 20
				HPmodifier = 4
				DMGmodifier = 1

				Death()
					emit(loc    = loc,
						 ptype  = /obj/particle/fluid/blood,
						 amount = 10,
						 angle  = new /Random(0, 360),
						 speed  = 5,
						 life   = new /Random(1,10))

				MapInit()
					set waitfor = 0
					..()

					SetSize(rand(5,15) / 10)

			Snake
				icon = 'Mobs.dmi'
				name = "Tiny Demon Snake"
				icon_state = "snake"
				level = 750
				MoveDelay = 2
				AttackDelay = 5
				Range = 20
				HPmodifier = 4
				DMGmodifier = 1

				MapInit()
					set waitfor = 0
					..()

					icon_state = pick("go_snake", "bg_snake", "white purple snake", "red and black snake")
					SetSize(rand(5,15) / 10)

			Blocked()
				density = 0
				var/turf/t = get_step_to(src, target, 1)
				if(t)
					Move(t)
				else
					..()
				density = 1

			Boss
				prizePoolSize = 4

				Attack()
					..()

				Search()
					step_rand(src)
					for(var/mob/Player/M in ohearers(src, Range))
						if(M.loc.loc != src.loc.loc) continue
						if(M.Immortal) continue

						target = M
						ChangeState(HOSTILE)

						spawn()
							var/time = 5
							while(src && state == HOSTILE && M == target && time > 0)
								sleep(30)
								time--

							if(M == target && state == HOSTILE)
								target = null
								ChangeState(SEARCH)

						break

				ChangeTarget()
					var/min_dist = Range
					for(var/mob/Player/M in ohearers(src, Range))
						if(M.Immortal) continue
						if(M.loc.loc != src.loc.loc) continue
						if(ignore && (M in ignore)) continue

						if(!isPathBlocked(M, src, 1, src.density, dist_limit=Range))
							var/dist = get_dist(src, M)
							if(min_dist > dist)
								target = M
						else
							Ignore(M)

				Basilisk
					icon = 'Mobs.dmi'
					icon_state = "basilisk"
					name = "Mini Basilisk"
					HPmodifier = 6
					DMGmodifier = 3
					MoveDelay = 3
					level = 2000

					MapInit()
						set waitfor = 0
						..()
						SetSize(2)

					Search()
						step_rand(src)
						for(var/mob/Player/M in ohearers(src, Range))
							if(M.loc.loc != src.loc.loc) continue
							if(M.Immortal) continue

							target = M
							ChangeState(HOSTILE)

							spawn()
								var/time = 5
								while(src && state == HOSTILE && M == target && time > 0)
									sleep(30)
									time--

								if(M == target && state == HOSTILE)
									target = null
									ChangeState(SEARCH)

							break

					Death()

				Acromantula
					icon = 'Mobs.dmi'
					name = "Bubbles the Spider"
					icon_state = "spider"
					level = 2000
					HPmodifier = 50
					DMGmodifier = 4
					MoveDelay = 3
					AttackDelay = 1
					Range = 20
					var/tmp
						fired       = 0
						damageTaken = 0

					MapInit()
						set waitfor = 0
						..()
						SetSize(5 + (rand(-10, 10) / 10))

						namefont.QuickName(src, "[name]", "#eee", "#e00", top=1, py=16)
						hpbar = new(src)

					Attack(mob/M)
						..()
						if(!fired && target && state == HOSTILE)
							fired = 1
							spawn(40) fired = 0

							var/list/dirs = DIRS_LIST
							for(var/d in dirs)
								castproj(icon_state = "quake", damage = Dmg, name = "rubble", cd = 0, lag = 1,Dir=d)
							sleep(AttackDelay)

					Attacked(obj/projectile/p)
						..()
						if(HP > 0)
							damageTaken += p.damage

							var/limit = 3
							var/threshold = max(MHP / 10, 2000)
							while(damageTaken >= threshold && limit)
								new /mob/Enemies/Summoned/Acromantula (loc)
								damageTaken -= threshold
								limit--

					Death()
						emit(loc    = loc,
							 ptype  = /obj/particle/fluid/blood,
							 amount = 100,
							 angle  = new /Random(0, 360),
							 speed  = 6,
							 life   = new /Random(1,25))
						..()

				Zombie
					name = "Zombie"
					HPmodifier = 50
					DMGmodifier = 2
					MoveDelay = 3
					AttackDelay = 3
					Range = 20
					level = 2000

					MapInit()
						set waitfor = 0
						..()

						if(prob(51))
							icon   = 'FemaleVampire.dmi'
							gender = FEMALE
						else
							icon   = 'MaleVampire.dmi'
							gender = MALE

						GenerateIcon(src)

						namefont.QuickName(src, "The [name]", "#eee", "#e00", top=1)
						hpbar = new(src)

					Attacked(obj/projectile/p)
						if(p.owner && isplayer(p.owner) && p.owner.loc.loc == loc.loc)
							if(MoveDelay == 3 && prob(30))
								MoveDelay = 1
								ChangeState(state)
								spawn(30)
									MoveDelay = 3
									ChangeState(state)

							if(p.icon_state == "blood")
								emit(loc    = src,
									 ptype  = /obj/particle/green,
									 amount = 2,
									 angle  = new /Random(1, 359),
									 speed  = 2,
									 life   = new /Random(15,20))
							else
								..()

				Anakin_Aetherwalker
					HPmodifier = 60
					DMGmodifier = 3
					MoveDelay = 3
					AttackDelay = 1
					Range = 22
					level = 2600
					icon = 'ammy.dmi'
					icon_state = "snow"

					var/tmp/dashed = 0

					MapInit()
						set waitfor = 0
						..()

						namefont.QuickName(src, "[name]", "#eee", "#e00", top=1)
						hpbar = new(src)

						var/mutable_appearance/ma = new

						ma.icon = 'potions_ingredients.dmi'
						ma.icon_state = "eye"

						var/list/images = list()

						for(var/d = 0 to 359 step 90)
							var/matrix/m = matrix()
							m.Translate(24, 0)
							ma.transform = turn(m, d)

							images += ma.appearance

						var/obj/o = new
						o.overlays = images

						var/matrix/m = matrix()
						m.Turn(90)
						animate(o, transform = m, time = 10, loop = -1)
						m.Turn(90)
						animate(transform = m, time = 10)
						m.Turn(90)
						animate(transform = m, time = 10)
						animate(transform = null, time = 10)

						vis_contents += o

						var/obj/Shadow/s = new

						s.pixel_y = -16
						s.appearance_flags |= RESET_TRANSFORM|PIXEL_SCALE

						vis_contents += s

						pixel_y += 16

					Attack()
						..()

						if(target)

							if(!dashed && get_dist(src, target) > 3 && prob(10))
								Dash(get_step_towards(target, src))

					proc/Dash(turf/t)
						set waitfor = 0

						dashed = 1

						var
							px = (x * 32) - (t.x * 32)
							py = (y * 32) - (t.y * 32)

						dir = get_dir(src, t)

						var/time = round(((abs(px) + abs(py)) / 32) * 0.5)

						var/list/ghosts = list()
						for(var/i = 1 to 4)
							var/image/o = new
							o.appearance = appearance
							o.alpha = 255 - i * 50

							o.pixel_x = px * 0.1 * i
							o.pixel_y = py * 0.1 * i

							ghosts += o

						var/underlaysTmp = underlays.Copy()
						underlays += ghosts

						animate(src, pixel_x = -px,
						             pixel_y = -py, time = time)


						sleep(time)
						pixel_x = 0
						pixel_y = 0

						density = 0
						Move(t)
						density = 1

						underlays = underlaysTmp

						sleep(50)
						dashed = 0

				Illusionist
					name = "Illusionist"
					HPmodifier = 50
					DMGmodifier = 3
					MoveDelay = 5
					AttackDelay = 1
					Range = 22
					level = 2500

					icon = 'FemaleVampire.dmi'

					var/tmp
						oldA
						firedMeteor  = 0
						firedAvada   = 0
						firedProtego = 0

					MapInit()
						set waitfor = 0
						..()

						if(prob(51))
							icon   = 'FemaleVampire.dmi'
							gender = FEMALE
						else
							icon   = 'MaleVampire.dmi'
							gender = MALE

						GenerateIcon(src)

						namefont.QuickName(src, "The [name]", "#eee", "#e00", top=1)
				//		hpbar = new(src)

						while(loc)

							Blur()
							sleep(20)
							if(!loc) break

							var/newX = x
							var/newY = y

							if(prob(35))
								newX += (4 + rand(4)) * pick(1,-1)
								newY += (4 + rand(4)) * pick(1,-1)
							else if(prob(50))
								newX += (4 + rand(4)) * pick(1,-1)
							else
								newY += (4 + rand(4)) * pick(1,-1)

							newX = clamp(newX, 1, 100)
							newY = clamp(newY, 1, 100)

							var/turf/t = locate(newX, newY, z)

							Dash(t)

							sleep(50)


					Attacked(obj/projectile/p)
						set waitfor = 0

						if(prob(15))
							hearers(20, src)<<"<span style=\"color:red;\"><b>[src]:</span></b> <font color=aqua>Episkey!"
							overlays+=image('attacks.dmi', icon_state = "heal")
							sleep(10)
							overlays-=image('attacks.dmi', icon_state = "heal")
							HP += p.damage
						else if(prob(10))
							overlays += /obj/Shield
							hearers(20, src)<< "<b><span style=\"color:red;\">[src]</b></span>: PROTEGO!"

							p.damage = round(2 * p.damage, 1)
							p.owner.Attacked(p, 1)

							sleep(10)
							overlays -= /obj/Shield
							return

						..(p)

					Attack()
						..()

						if(target)

							if(!firedAvada && get_dist(src, target) <= 5)
								Avada()

							else if(!firedMeteor)
								Meteor()

					proc/Avada()
						set waitfor = 0

						firedAvada = 1

						var/vector/start = new (x        * world.icon_size + world.icon_size / 2, y        * world.icon_size + world.icon_size / 2)
						var/vector/dest  = new (target.x * world.icon_size + world.icon_size / 2, target.y * world.icon_size + world.icon_size / 2)

						start.X += (EAST & dir) ? 7 : -7
						start.Y -= 6

						var/bolt/boltFix/b = new(start, dest, 35)

						var/c = "#ff3030" // "#30ff30"

						b.Draw(z, /obj/segment/segmentFix, color = c, thickness = 1)

						light(b.lastCreatedBolt, 3, 10, "circle", c)

						emit(loc    = target.loc,
							 ptype  = /obj/particle/smoke/proj,
						     amount = 28,
						     angle  = new /Random(0, 360),
						     speed  = 2,
						     life   = new /Random(20,35),
						     color  = c)

						target.onDamage(target.MHP * 0.35, src)
						target.Death_Check(src)

						sleep(50)
						firedAvada = 0

					proc/Meteor()
						set waitfor = 0

						firedMeteor = 1

						var/obj/boss/death/d = new (target.loc, src, pick(3,5,7))
						d.density = 1
						for(var/i = 1 to rand(0,4))
							step_away(d, src)
						d.density = 0

						sleep(20)
						firedMeteor = 0

					proc/Dash(turf/t)
						set waitfor = 0

						var
							px = (x * 32) - (t.x * 32)
							py = (y * 32) - (t.y * 32)

						dir = get_dir(src, t)

						var/time = round(((abs(px) + abs(py)) / 32) * 0.5)

						var/list/ghosts = list()
						for(var/i = 1 to 4)
							var/image/o = new
							o.appearance = appearance
							o.alpha = 255 - i * 50

							o.pixel_x = px * 0.1 * i
							o.pixel_y = py * 0.1 * i

							ghosts += o

						var/underlaysTmp = underlays.Copy()
						underlays += ghosts

						animate(src, pixel_x = -px,
						             pixel_y = -py, time = time)


						sleep(time)
						pixel_x = 0
						pixel_y = 0

						density = 0
						Move(t)
						density = 1

						underlays = underlaysTmp

					proc/Blur()
						set waitfor = 0

						var/offsetX = rand(-1, 1)
						var/offsetY = rand(-1, 1)

						var/const/RANGE = 1

						animate(src, alpha = 0, time = 4)
						sleep(4)

						alpha = 255

						if(oldA)
							appearance = oldA
						else
							oldA = appearance

						var/list/blurs = list()

						var/obj/o = new
						o.appearance = appearance
						o.alpha = 150

						if(prob(35))
							o.pixel_x = 128 * pick(1, -1)
							o.pixel_y = 128 * pick(1, -1)
						else if(prob(45))
							o.pixel_x = 128 * pick(1, -1)
						else
							o.pixel_y = 128 * pick(1, -1)

						blurs += o.appearance

						for(var/i = -RANGE + offsetX to RANGE + offsetX)
							for(var/j = -RANGE + offsetY to RANGE + offsetY)
								if(i == 0 && j == 0) continue

								if(prob(30)) continue

								o.pixel_x = i*32
								o.pixel_y = j*32

								if(prob(10))
									o.pixel_x *= 2

								if(prob(10))
									o.pixel_y *= 2

								if(prob(50)) o.alpha = rand(120, 200)
								else o.alpha = 255

								blurs += o.appearance

						overlays += blurs

						alpha = 0
						animate(src, alpha = 255, time = 4)

				Ghost
					name = "Vengeful Ghost"
					icon = 'NPCs.dmi'
					HPmodifier = 4
					layer = 5
					MoveDelay = 2
					AttackDelay = 3
					Range = 15
					level = 850
					canBleed = FALSE
					prizePoolSize = 1

					element = GHOST

					MapInit()
						set waitfor = 0
						..()

						if(prob(51))
							icon   = 'FemaleStaff.dmi'
							gender = FEMALE
						else
							icon   = 'MaleStaff.dmi'
							gender = MALE

						GenerateIcon(src)

						alpha = rand(100,180)

						animate(src, color = "#f55", pixel_y = 2,  time = 6, loop = -1)
						animate(     color = "#f55", pixel_y = 0,  time = 6)
						animate(     color = null,   pixel_y = -2, time = 6)

					Attacked(obj/projectile/p)

						if(p.owner && isplayer(p.owner) && p.owner.loc.loc == loc.loc)

							if(prob(40))
								var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
								while(dirs.len)
									var/d = pick(dirs)
									dirs -= d
									var/turf/t = get_step(p.owner, d)
									if(t && t.loc == loc.loc)
										target = p.owner
										loc    = t
										break

						if(p.element == GHOST || (p.icon_state == "blood" && prob(75)))
							..()
							emit(loc    = src,
								 ptype  = /obj/particle/red,
								 amount = 2,
								 angle  = new /Random(1, 359),
								 speed  = 2,
								 life   = new /Random(15,20))
						else
							emit(loc    = src,
								 ptype  = /obj/particle/green,
								 amount = 2,
								 angle  = new /Random(1, 359),
								 speed  = 2,
								 life   = new /Random(15,20))

				Treasure_Chest
					icon = 'Chest.dmi'
					HPmodifier = 15
					layer = 5
					MoveDelay = 5
					AttackDelay = 5
					Range = 1
					level = 1000
					canBleed = FALSE
					prizePoolSize = 1
					extraDropRate = 60

					MapInit()
						set waitfor = 0
						..()

						icon_state = pick("purple", "red", "blue", "green", "orange", "pink")

						SetSize(2)

						namefont.QuickName(src, "[name]", "#eee", "#e00", top=1, py=16)
						hpbar = new(src)

						sleep(360)

						Dispose()
						ChangeState(INACTIVE)

					Search()
						sleep(lag)

					Attack()
						sleep(lag)

					Move()
						if(state == WANDER) return
						.=..()

					onDamage(dmg, mob/Player/p, elem = 0, projColor=null)
						if((RING_AFK in p.passives))
							dmg *= 2
						..(dmg, p, elem, projColor)

				Scared_Ghost
					icon = 'NPCs.dmi'
					HPmodifier = 5
					layer = 5
					MoveDelay = 5
					AttackDelay = 5
					Range = 15
					level = 1000
					canBleed = FALSE
					prizePoolSize = 1
					extraDropRate = 30

					element = GHOST

					MapInit()
						set waitfor = 0
						..()

						if(prob(51))
							icon   = 'FemaleStaff.dmi'
							gender = FEMALE
						else
							icon   = 'MaleStaff.dmi'
							gender = MALE

						GenerateIcon(src)

						alpha = rand(100,180)

						sleep(210)

						Dispose()
						ChangeState(INACTIVE)

					Attack()

						if(prob(25))
							step(src, pick(DIRS_LIST))
							sleep(lag)

						var/turf/t = get_step_away(src, target)

						if(!t)
							step_rand(src)
						else
							Move(t)

					Attacked(obj/projectile/p)

						if(p.element == GHOST || (p.icon_state == "blood" && prob(80)))
							..()
							emit(loc    = src,
								 ptype  = /obj/particle/red,
								 amount = 2,
								 angle  = new /Random(1, 359),
								 speed  = 2,
								 life   = new /Random(15,20))
						else
							emit(loc    = src,
								 ptype  = /obj/particle/green,
								 amount = 2,
								 angle  = new /Random(1, 359),
								 speed  = 2,
								 life   = new /Random(15,20))

					onDamage(dmg, mob/Player/p, elem = 0, projColor=null)
						if((RING_AFK in p.passives))
							dmg *= 2
						..(dmg, p, elem, projColor)


				VampireLord
					name = "Vampire Lord"
					icon = 'FemaleVampire.dmi'
					icon_state = "flying"
					HPmodifier = 50
					DMGmodifier = 3
					MoveDelay = 3
					AttackDelay = 1
					Range = 20
					level = 2000

					var/tmp/fired = 0

					MapInit()
						set waitfor = 0
						..()

						if(prob(49))
							icon   = 'MaleVampire.dmi'
							gender = MALE
						else
							gender = FEMALE

						GenerateIcon(src)

						var/image/i = new('VampireWings.dmi', "flying")
						i.layer = FLOAT_LAYER - 3
						i.pixel_x = -16
						i.pixel_y = -16
						i.color   = rgb(rand(0,255), rand(0,255), rand(0,255))

						overlays += i

						animate(src, pixel_y = pixel_y,      time = 2, loop = -1)
						animate(     pixel_y = pixel_y + 1,  time = 2)
						animate(     pixel_y = pixel_y,      time = 2)
						animate(     pixel_y = pixel_y - 1,  time = 2)

						namefont.QuickName(src, "[name]", "#eee", "#e00", top=1, px=0, py=2)
						hpbar = new(src)

					Attack(mob/M)
						..()
						if(!fired && target && state == HOSTILE)
							fired = 1
							spawn(30) fired = 0

							if(prob(25))

								var/hp = 0

								for(var/mob/Player/p in oview(9, src))
									hp++
									emit(loc    = p.loc,
										 ptype  = /obj/particle/fluid/blood,
										 amount = 60,
										 angle  = new /Random(get_angle(src, p) + 95, get_angle(src, p) + 85),
										 speed  = 6,
										 life   = new /Random(1,50))

									p << errormsg("[name] fed on your blood.")

									p.onDamage(1500, src)
									p.Death_Check(src)

								HP += hp * 250
								if(HP > MHP)
									HP = MHP

							else

								for(var/obj/redroses/S in oview(3, src))
									flick("burning", S)
									spawn(8) S.loc = null


								var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
								for(var/d in dirs)
									castproj(Type = /obj/projectile/Blood, icon_state = "blood", damage = Dmg + rand(-4,8), name = "Cruor", cd = 0, lag = 1, Dir=d)
								sleep(AttackDelay)

					Attacked(obj/projectile/p)

						if(p.owner && isplayer(p.owner) && p.owner.loc.loc == loc.loc)

							if(prob(55))
								var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
								while(dirs.len)
									var/d = pick(dirs)
									dirs -= d
									var/turf/t = get_step(p.owner, d)
									if(t.loc == loc.loc)
										target = p.owner
										loc    = t
										break
							else if(MoveDelay == 3 && prob(45))
								MoveDelay = 1
								ChangeState(state)
								spawn(rand(40,60))
									MoveDelay = 3
									ChangeState(state)

						p.damage = round(p.damage * rand(5, 10)/10)

						..()

					Death()
						emit(loc    = loc,
							 ptype  = /obj/particle/fluid/blood,
							 amount = 60,
							 angle  = new /Random(0, 360),
							 speed  = 4,
							 life   = new /Random(1,25))
						..()


				Wisp
					icon = 'Mobs.dmi'
					icon_state = "wisp"
					name = "Willy the Whisp"
					HPmodifier = 50
					DMGmodifier = 2
					layer = 5
					MoveDelay = 3
					AttackDelay = 1
					Range = 15
					level = 2000
					var/tmp/fired = 0
					var/proj = "gum"
					canBleed = FALSE

					MapInit()
						set waitfor = 0
						..()
						alpha = rand(190,240)

						var/color1 = rgb(rand(20, 255), rand(20, 255), rand(20, 255))
						var/color2 = rgb(rand(20, 255), rand(20, 255), rand(20, 255))
						var/color3 = rgb(rand(20, 255), rand(20, 255), rand(20, 255))

						animate(src, color = color1, time = 10, loop = -1)
						animate(color = color2, time = 10)
						animate(color = color3, time = 10)

						SetSize(3 + (rand(-10, 10) / 10))

						namefont.QuickName(src, "[name]", "#eee", "#e00", top=1, py=16)
						hpbar = new(src)

						while(loc)
							proj = pick(list("gum", "quake", "iceball","fireball", "aqua", "black") - proj)
							switch(proj)
								if("gum")
									animate(src, color = "#fa8bd8", time = 10, loop = -1)
									animate(color = "#c811f1", time = 10)
									animate(color = "#ec06a3", time = 10)
								if("quake")
									animate(src, color = "#aa8d84", time = 10, loop = -1)
									animate(color = "#767309", time = 10)
									animate(color = "#a4903d", time = 10)
								if("iceball")
									animate(src, color = "#24e3f3", time = 10, loop = -1)
									animate(color = "#a4bcd3", time = 10)
									animate(color = "#4a9ee0", time = 10)
								if("fireball")
									animate(src, color = "#dd6103", time = 10, loop = -1)
									animate(color = "#b21039", time = 10)
									animate(color = "#b81114", time = 10)
								if("black")
									animate(src, color = "#000000", time = 10, loop = -1)
									animate(color = "#ffffff", time = 10)
								if("aqua")
									animate(src, color = "#0e3492", time = 10, loop = -1)
									animate(color = "#2a32fb", time = 10)
									animate(color = "#cdf0e3", time = 10)
							sleep(600)

					Attack(mob/M)
						..()
						if(!fired && target && state == HOSTILE)
							fired = 1
							spawn(40) fired = 0

							for(var/obj/redroses/S in oview(3, src))
								flick("burning", S)
								spawn(8) S.loc = null

							if(prob(80))
								var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
								for(var/d in dirs)
									castproj(icon_state = "fireball", damage = Dmg + rand(-4,8), name = "fire ball", cd = 0, lag = 1,Dir=d)
								sleep(AttackDelay)

					Attacked(obj/projectile/p)
						if(p.icon_state == proj || (p.icon_state == "blood" && prob(65)))
							..()
							emit(loc    = src,
								 ptype  = /obj/particle/red,
								 amount = 2,
								 angle  = new /Random(1, 359),
								 speed  = 2,
								 life   = new /Random(15,20))
						else
							emit(loc    = src,
								 ptype  = /obj/particle/green,
								 amount = 2,
								 angle  = new /Random(1, 359),
								 speed  = 2,
								 life   = new /Random(15,20))


				Sword
					icon = 'Mobs_128x128.dmi'
					icon_state = "sword"
					iconSize = 4
					pixel_x = -48
					pixel_y = -24
					name = "The Black Blade"
					HPmodifier = 60
					DMGmodifier = 3
					layer = 5
					MoveDelay = 3
					AttackDelay = 1
					Range = 20
					level = 2000
					canBleed = FALSE
					var/tmp
						fired = 0
						diag  = 0
						obj/Shadow/s

					Move(newLoc)
						if(s)
							s.glide_size = glide_size
							s.loc = newLoc
						..()

					MapInit()
						set waitfor = 0
						..()

						s = new (loc)
						s.transform = matrix() * 4

						SetSize(4)

						animate(src, pixel_y = 0, time = 2, loop = -1)
						animate(pixel_y = 1, time = 2)
						animate(pixel_y = 0, time = 2)
						animate(pixel_y = -1, time = 2)

						namefont.QuickName(src, "[name]", "#eee", "#e00", top=1, py=16)
						hpbar = new(src)

						while(loc)

							icon_state = "shield"
							MoveDelay = 40
							ChangeState(state)
							reflect = 2

							var/spawns = 4
							while(loc && spawns > 0)
								spawns--

								var/RandomEvent/Sword/e = locate() in worldData.currentEvents
								if(e)
									if(e.swords < 30)
										e.swords+=2
										new /mob/Enemies/Summoned/Sword (loc)
										new /mob/Enemies/Summoned/Sword (loc)

								sleep(50)

							icon_state = "sword"
							reflect = 0
							MoveDelay = 3
							ChangeState(state)

							sleep(600)

					Attack(mob/M)
						..()

						if(!fired && target && state == HOSTILE && icon_state == "sword")
							fired = 1
							spawn(30) fired = 0

							var/list/dirs
							if(diag == 0)
								dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
								diag = 1
							else if(diag == 1)
								dirs = list(NORTH, SOUTH, EAST, WEST)
								diag = 2
							else if(diag == 2)
								dirs = list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
								diag = 0
							for(var/d in dirs)
								castproj(icon_state = "sword", name = "flying sword", cd = 0, lag = 1,Dir=d)

					Attacked(obj/projectile/p)
						if(icon_state == "shield" || p.icon_state == "blood")
							emit(loc    = src,
								 ptype  = /obj/particle/green,
								 amount = 2,
								 angle  = new /Random(1, 359),
								 speed  = 2,
								 life   = new /Random(15,20))
						else
							..()

					Death(mob/Player/killer)
						if(s)
							s.loc = null
							s = null
						..()


				Golem
					icon = 'Mobs_128x128.dmi'
					icon_state = "golem"
					iconSize = 4
					pixel_x = -48
					pixel_y = -24
					name = "Stone Golem"
					HPmodifier = 60
					DMGmodifier = 2
					layer = 5
					MoveDelay = 3
					AttackDelay = 1
					Range = 15
					level = 2000
					canBleed = FALSE
					var/tmp/fired = 0

					prizePoolSize = 5

					MapInit()
						set waitfor = 0
						..()
						namefont.QuickName(src, "[name]", "#eee", "#e00", top=1, py=16)
						hpbar = new(src)

					Attack(mob/M)
						..()
						if(!fired && target && state == HOSTILE)
							fired = 1
							spawn(rand(18,38)) fired = 0

							var/r = rand(3,8)
							var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)

							for(var/i = 1 to r)
								var/d = pick(dirs)
								dirs -= d
								castproj(Type = /obj/projectile/Grav, icon_state = "grav", name = "Gravitate", cd = 0, lag = 1, Dir=d)
							sleep(AttackDelay)

					Attacked(obj/projectile/p)
						if(p.icon_state == "iceball" || p.icon_state == "aqua" || (p.icon_state == "blood" && prob(60)))
							..()
							emit(loc    = src,
								 ptype  = /obj/particle/red,
								 amount = 2,
								 angle  = new /Random(1, 359),
								 speed  = 2,
								 life   = new /Random(15,20))
						else
							emit(loc    = src,
								 ptype  = /obj/particle/green,
								 amount = 2,
								 angle  = new /Random(1, 359),
								 speed  = 2,
								 life   = new /Random(15,20))

					Death(mob/Player/killer)
						if(killer)
							worldData.elderWand = killer.ckey
							Players << infomsg("Stone Golem was defeated and the elder wand's magic power was harnessed by <b>[killer.name]</b> ")
						..()

				Snowman
					icon = 'Snowman.dmi'
					name = "The Evil Snowman"
					HPmodifier = 50
					DMGmodifier = 3
					layer = 5
					MoveDelay = 3
					AttackDelay = 1
					Range = 15
					level = 2000
					var/tmp
						fired = 0
						extraDmg = 400
					element = WATER

					MapInit()
						set waitfor = 0
						..()
						namefont.QuickName(src, "[name]", "#eee", "#e00", top=1, py=16)
						hpbar = new(src)

					Death()
						..()
						SpawnPortal("teleportPointSnowman Dungeon")


					Attack(mob/M)
						..()
						if(!fired && target && state == HOSTILE)
							fired = 1
							spawn(40) fired = 0

							var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
							var/dmg = round(Dmg * 1.5 + rand(-4,8))
							for(var/d in dirs)
								castproj(icon_state = "snowball", damage = dmg, name = "snowball", cd = 0, lag = 1, Dir=d)
							sleep(AttackDelay)

					Attacked()
						..()
						if(HP > 0)
							var/percent = MHP / HP
							var/matrix/M = matrix() * min(percent, 8)
							transform = M

							Dmg = DMGmodifier * (level + 5) + (percent * 400)

							percent = (1 / percent) * 100

							if(percent <= 50 && MoveDelay == 3)
								MoveDelay = 2
								ChangeState(state)

				Stickman
					icon_state = "stickman"
					name = "Mini Stickman"
					level = 500
					HPmodifier  = 1
					DMGmodifier = 1

					MoveDelay   = 3
					AttackDelay = 1

					var/tmp/fired = 0

					Death()


					BlindAttack()
						spawn()
							for(var/i = 1 to 3)
								castproj(icon_state = "gum", damage = Dmg + rand(-4,8), name = "Waddiwasi")
								sleep(4)

					Attack()
						if(!target || !target.loc || target.loc.loc != loc.loc || !(target in ohearers(src,Range)))
							target = null
							ShouldIBeActive()
							return

						if(prob(30))
							ChangeTarget()

						var/distance = get_dist(src, target)
						if(distance > 5)
							var/turf/t = get_step_to(src, target, 1)
							if(t)
								Move(t)
							else
								target = null
								ShouldIBeActive()
						else if(distance <= 3)
							step_away(src, target)
						else if(distance > 3)
							step_rand(src)

						dir=get_dir(src, target)
						if(AttackDelay)	sleep(AttackDelay)
						castproj(icon_state = "gum", damage = Dmg + rand(-4,8), name = "Waddiwasi")


		Stickman
			icon = 'Mobs.dmi'
			icon_state = "stickman"
			level = 2100
			HPmodifier  = 10
			DMGmodifier = 2

			MoveDelay   = 2
			AttackDelay = 0

			prizePoolSize = 3

			var/tmp/fired = 0

			Range = 16
			respawnTime = 3000

			drops = "duelist"

			MapInit()
				set waitfor = 0
				..()
				SetSize(2)

				namefont.QuickName(src, "The [name]", "#eee", "#e00", top=1, py=16)
				hpbar = new(src)

			ChangeState(var/i_State)
				..(i_State)

				if(state == 0 && origloc && HP > 0)
					loc = origloc

			Attack()
				if(!target || !target.loc || target.loc.loc != loc.loc || !(target in ohearers(src,Range)))
					target = null
					ShouldIBeActive()
					return

				if(prob(30))
					ChangeTarget()

				var/distance = get_dist(src, target)
				if(distance > 5)
					var/turf/t = get_step_to(src, target, 1)
					if(t)
						Move(t)
					else
						target = null
						ShouldIBeActive()
				else if(distance <= 3)
					step_away(src, target)
				else if(distance > 3)
					step_rand(src)

				if(prob(20) && !fired)
					fired = 1
					spawn(100) fired = 0
					var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
					var/tmp_d = dir
					var/dmg = round(Dmg * 0.8) + rand(-4, 12)
					for(var/d in dirs)
						dir = d
						castproj(icon_state = "fireball", damage = dmg, name = "Incindia", cd = 0, lag = 1)
					dir = tmp_d
				else
					dir=get_dir(src, target)
					if(AttackDelay)	sleep(AttackDelay)
					castproj(icon_state = "gum", damage = Dmg + rand(-4, 12), name = "Waddiwasi")

			Blocked()
				density = 0
				var/turf/t = get_step_to(src, target, 1)
				if(t)
					Move(t)
				else
					..()
				density = 1

			Kill(mob/Player/p)
				set waitfor = 0
				..(p)

				sleep(1)

				var/hudobj/teleport/t = new (null, p.client, null, show=1)
				t.dest = "CoSBoss2Out"
				p << errormsg("Click the teleport stone on screen button at the bottom right to go back to the Stickman.")

			Death(mob/Player/killer)
				..(killer)

				SpawnPortal("teleportPointCoS Floor 3", "CoSBoss2LockDoor", lava=1, timer=1)

		// NORMAL MONSTER START

		Rat
			icon_state  = "rat"
			level       = 50
			HPmodifier  = 0.2
			DMGmodifier = 0.1

			Death(mob/Player/killer)
				..()

				SpawnPet(killer, 0.6, null, /obj/items/wearable/pets/rat)


		Demon_Rat
			icon_state = "rat"
			level = 700

			Death(mob/Player/killer)
				..()

				SpawnPet(killer, 0.9, null, /obj/items/wearable/pets/rat)

				SpawnPortal(pickweight(dungeons), chance=0.1)

		Training_Dummy
			icon_state = "dummy"
			level = 700

			Death(mob/Player/killer)
				..()

				SpawnPet(killer, 0.1, null, /obj/items/wearable/pets/training_dummy)

				SpawnPortal(pickweight(dungeons), chance=0.1)

		Pixie
			icon_state  = "pixie"
			level       = 100
			HPmodifier  = 0.4
			DMGmodifier = 0.2

			Death(mob/Player/killer)
				..()

				SpawnPet(killer, 0.3, null, /obj/items/wearable/pets/pixie)

		Dog
			icon_state  = "dog"
			level       = 150
			HPmodifier  = 0.8
			DMGmodifier = 0.4

			Death(mob/Player/killer)
				..()

				SpawnPet(killer, 0.1, null, /obj/items/wearable/pets/dog)

		Snake
			icon_state  = "snake"
			level       = 200

			Death(mob/Player/killer)
				..()

				SpawnPet(killer, 0.1, null, /obj/items/wearable/pets/snake)

				if(killer.level >= 700)
					SpawnPortal("teleportPointSnake Dungeon", chance=0.5)

		Wolf
			icon_state  = "wolf"
			level       = 300

			Death(mob/Player/killer)
				..()

				SpawnPet(killer, 0.1, null, /obj/items/wearable/pets/wolf)

		Cow
			icon_state  = "cow"
			level       = 1000
			HPmodifier  = 1.5
			DMGmodifier = 0.5

			extraDropRate = 3

			respawnTime = 300

			Cow_Queen
				level = 2000
				isElite = 1

				HPmodifier = 3

				MapInit()
					set waitfor = 0
					..()
					origloc = null

			Death(mob/Player/killer)
				..()

				if(origloc)
					SpawnPet(killer, 0.2, null, /obj/items/wearable/pets/Cow)

					var/obj/kill_counter/count = locate("Counter_Cows")
					if(count.add())
						new /mob/Enemies/Cow/Cow_Queen (locate(rand(5,61), rand(52,96), 20))

		Pumpkin
			icon = 'Mobs.dmi'
			icon_state  = "pumpkin"
			canBleed    = FALSE
			level       = 750
			HPmodifier  = 3
			DMGmodifier = 1
			MoveDelay = 3
			AttackDelay = 2


			Attacked()
				..()
				if(HP > 0)
					var/percent = 1 + (1 - HP / MHP) * 2
					percent = min(3, percent)
					percent = max(1, percent)
					animate(src, SetSize(percent), time = 5, easing = ELASTIC_EASING)

			Death(mob/Player/killer)
				..()

				var/rr = rand(40, 240)
				var/gg = rand(40, 240)
				var/bb = rand(40, 240)

				if(abs(rr - gg) < 20)      rr = 255 - gg

				emit(loc    = loc,
					 ptype  = /obj/particle/smoke/green,
					 amount = 10,
					 angle  = new /Random(1, 359),
					 speed  = 2,
					 life   = new /Random(15,25),
					 color  = rgb(rr,gg,bb))

				for(var/mob/Player/p in oview(src, 2))
					var/d =  round((p.MHP) * 0.2, 1) + rand(-100, 100)
					p << errormsg("The pumpkin's explosion hit you for [d] damage.")

					p.HP -= d

					if(p.HP <= 0)
						p.Death_Check(src)
					else
						p.updateHP()

				SpawnPet(killer, 0.1, null, /obj/items/wearable/pets/pumpkin)


		The_Good_Snowman
			icon_state = "snowman"
			level = 2300
			HPmodifier = 15
			DMGmodifier = 3
			MoveDelay = 3
			AttackDelay = 1
			Range = 24
			respawnTime = 3000
			prizePoolSize = 3

			element = WATER

			var/attempts = 3

			ChangeState(var/i_State)
				..(i_State)

				if(state == 0 && origloc && HP > 0)
					if(attempts-- <= 0)
						attempts = initial(attempts)
						HP = MHP
					loc = origloc

			MapInit()
				set waitfor = 0
				..()
				SetSize(3)

				namefont.QuickName(src, name, "#eee", "#e00", top=1, py=16)

				hpbar = new(src)

			var/tmp/fired = 0

			Blocked()
				density = 0
				var/turf/t = get_step_to(src, target, 1)
				if(t)
					Move(t)
				else
					..()
				density = 1

			Attack()
				..()

				if(target && !fired)
					fired = 1
					spawn(10)
						fired = 0

					var/obj/boss/death/d = new (target.loc, src, pick(3,5,7))
					d.density = 1
					for(var/i = 1 to rand(0,4))
						step_away(d, src)
					d.density = 0

			Attacked()
				..()
				if(HP > 0)
					var/percent = 1 + (HP / MHP)*2
					var/matrix/M = matrix() * percent
					transform = M
				else
					transform = matrix() * 3



			Kill(mob/Player/p)
				set waitfor = 0
				..(p)

				sleep(1)

				var/hudobj/teleport/t = new (null, p.client, null, show=1)
				t.dest = "teleportPointSnowman Dungeon"
				p << errormsg("Click the teleport stone on screen button at the bottom right to go back to the snowman dungeon.")



			Death(mob/Player/killer)
				set waitfor = 0
				..(killer)

				SpawnPortal("teleportPointSnowman Dungeon", timer=1)

		Snowman
			icon = 'Snowman.dmi'
			level = 750
			HPmodifier  = 3
			element = WATER

			onDamage(dmg, mob/Player/p, elem = 0, projColor=null)
				..(dmg, p, elem, projColor)

				if(HP > 0)

					var/maxHP = getHardmodeHealth()

					var/percent = clamp(HP / maxHP, 0.1, 1)
					percent = 1 + (1 - percent)*2

					if(isElite) percent += 2

					var/matrix/M = matrix() * percent
					transform = M

					Dmg = round(DMGmodifier * (level + 5) * (percent))
				else
					transform = null
					Dmg = DMGmodifier * (level + 5)

		Akalla
			icon_state = "basilisk"
			level = 2400
			HPmodifier = 25
			DMGmodifier = 3
			MoveDelay = 3
			AttackDelay = 1
			Range = 24
			respawnTime = 3000
			prizePoolSize = 3

			var/attempts = 3

			ChangeState(var/i_State)
				..(i_State)

				if(state == 0 && origloc && HP > 0)
					loc = origloc
					var/obj/boss/deathDOTControl/c = locate("AkallaDeathControl")
					c.Stop()

					if(attempts-- <= 0)
						attempts = initial(attempts)
						HP = MHP
				else
					var/obj/boss/deathDOTControl/c = locate("AkallaDeathControl")
					c.Start()

			MapInit()
				set waitfor = 0
				..()
				SetSize(3)

				namefont.QuickName(src, name, "#eee", "#e00", top=1, py=16)

				hpbar = new(src)

			var/tmp
				fired = 0
				fired2 = 0

			Blocked()
				density = 0
				var/turf/t = get_step_to(src, target, 1)
				if(t)
					Move(t)
				else
					..()
				density = 1

			Attack()
				..()

				if(target)

					if(!fired2)
						fired2 = 1
						spawn(rand(40, 80)) fired2 = 0

						var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
						for(var/d in dirs)
							castproj(Type = /obj/projectile/Bomb, icon_state = "bombarda", damage = Dmg*0.75, name = "Bomb", cd = 0, lag = 1, Dir=d)

					if(!fired)

						fired = 1
						spawn()

							var/obj/warnWidth  = new /obj/custom { icon = 'dot.dmi'; icon_state = "circle"; color = "#8A0707"; alpha = 20; appearance_flags = PIXEL_SCALE; } (loc)
							var/obj/warnHeight = new /obj/custom { icon = 'dot.dmi'; icon_state = "circle"; color = "#8A0707"; alpha = 20; appearance_flags = PIXEL_SCALE; } (loc)

							walk_towards(warnWidth, src)
							walk_towards(warnHeight, src)

							var/matrix/mWidth = matrix()
							mWidth.Scale(17,1)

							var/matrix/mHeight = matrix()
							mHeight.Scale(1,17)

							animate(warnWidth,  alpha = 100, transform = mWidth, time = 7)
							animate(warnHeight, alpha = 100, transform = mHeight, time = 7)

							sleep(30)

							walk(warnWidth, 0)
							warnWidth.loc = null

							walk(warnHeight, 0)
							warnHeight.loc = null

							for(var/mob/Player/p in ohearers(8, src))
								if(p.x == x || p.y == y)
									p.ApplyEffect("stone")

							sleep(rand(50,150))
							fired  = 0
							fired2 = 0

			Attacked()
				..()


			Kill(mob/Player/p)
				set waitfor = 0
				..(p)

				sleep(1)

				var/hudobj/teleport/t = new (null, p.client, null, show=1)
				t.dest = "teleportPointSnake Dungeon"
				p << errormsg("Click the teleport stone on screen button at the bottom right to go back to the snake dungeon.")



			Death(mob/Player/killer)
				set waitfor = 0
				..(killer)

				var/obj/boss/deathDOTControl/c = locate("AkallaDeathControl")
				c.Stop()

				SpawnPortal("teleportPointSnake Dungeon", timer=1)

		Demon_Snake
			icon = 'Mobs.dmi'

			icon_state = "snake"
			level = 850
			MoveDelay = 3

			HPmodifier = 4
			DMGmodifier = 1

			ChangeState(var/i_State)
				set waitfor = FALSE

				..(i_State)

				if(i_State == WANDER && origloc && HP > 0)
					HP = MHP
					while(state == WANDER && get_dist(loc, origloc) > 2)
						var/i = step_to(src, origloc)
						if(!i) break
						sleep(1)

			Death(mob/Player/killer)
				..()

				var/s = prob(45) ? 2 : 1
				for(var/i = 1 to s)
					new /mob/Enemies/Summoned/Snake (loc)

				SpawnPet(killer, 0.05, null, /obj/items/wearable/pets/demon_snake)


			MapInit()
				set waitfor = 0
				..()

				icon_state = pick("go_snake", "bg_snake", "white purple snake", "red and black snake")

				if(isElite)
					SetSize(3)
				else
					SetSize(rand(15,25) / 10)


		Acromantula
			icon = 'Mobs.dmi'

			icon_state = "spider"
			level = 850
			MoveDelay = 3

			HPmodifier = 3.2

			respawnTime = 900

			ChangeState(var/i_State)
				set waitfor = FALSE

				..(i_State)

				if(i_State == WANDER && origloc && HP > 0)
					HP = MHP
					while(state == WANDER && get_dist(loc, origloc) > 2)
						var/i = step_to(src, origloc)
						if(!i) break
						sleep(1)

			Death(mob/Player/killer)
				emit(loc    = loc,
					 ptype  = /obj/particle/fluid/blood,
					 amount = 10,
					 angle  = new /Random(0, 360),
					 speed  = 5,
					 life   = new /Random(5,15))
				..()

				var/s = prob(45) ? 2 : 1
				for(var/i = 1 to s)
					new /mob/Enemies/Summoned/Acromantula (loc)


				SpawnPet(killer, 0.2, null, /obj/items/wearable/pets/acromantula)
				SpawnPortal(pickweight(dungeons), chance=2)

			MapInit()
				set waitfor = 0
				..()

				SetSize(rand(15,30) / 10)

		Vampire
			icon = 'FemaleVampire.dmi'
			level = 900
			HPmodifier  = 4
			DMGmodifier = 1
			MoveDelay   = 3
			respawnTime = 900

			drops = "Vampire"

			var/rep = 4
			var/tmp/areaName

			MapInit()
				set waitfor = 0
				..()
				if(prob(49))
					icon   = 'MaleVampire.dmi'
					gender = MALE
				else
					gender = FEMALE

				GenerateIcon(src)

				sleep(2)
				if(loc)
					areaName = "area_[loc.loc.name]"

			ShouldIBeActive()
				..()

				if(rep != 0)
					var/AreaData/data = worldData.areaData[areaName]

					if(data)
						if(data.rep > 0)
							rep = abs(rep)
						else if(data.rep < 0)
							rep = -abs(rep)
						faction()



			proc/faction()
				if(rep < 0)
					name = "Peace Vampire"
				else if(rep > 0)
					name = "Chaos Vampire"
				else
					name = "Vampire"

			Death(mob/Player/killer)
				emit(loc    = loc,
				 ptype  = /obj/particle/fluid/blood,
					 amount = 10,
					 angle  = new /Random(0, 360),
					 speed  = 5,
					 life   = new /Random(1,10))

				if(killer && !killer.Immortal)

		//			var/r = rep
		//			if(prob(52)) r /= 2

			//		killer.addRep(r)

					var/obj/countdown/c = locate(areaName)
					if(c)
						c.add(1, killer.guild)

				..()

			onDamage(dmg, mob/Player/p, elem = 0, projColor=null)
				dmg = round(dmg * rand(7, 9)/10)
				if(MoveDelay == 3 && p && prob(55))
					MoveDelay = 1
					ChangeState(state)
					spawn(30)
						MoveDelay = 3
						ChangeState(state)
				..(dmg, p, elem, projColor)

			ChangeState(var/i_State)
				set waitfor = FALSE

				..(i_State)

				if(i_State == WANDER && origloc && HP > 0)
					HP = MHP
					while(state == WANDER && get_dist(loc, origloc) > 2)
						var/i = step_to(src, origloc)
						if(!i) break
						sleep(1)


		Wisp
			icon = 'Mobs.dmi'

			icon_state = "wisp"
			level = 850

			HPmodifier  = 4
			DMGmodifier = 1
			MoveDelay = 3
			canBleed = FALSE
			var/tmp/fired = 0

			element = GHOST

			Attack(mob/M)
				..()
				if(!fired && target && state == HOSTILE)
					fired = 1
					spawn(90) fired = 0

					for(var/obj/redroses/S in oview(3, src))
						flick("burning", S)
						spawn(8) S.loc = null

					var/dmg = Dmg + rand(-4,8)

					if(hardmode)
						dmg = getHardmodeDamage(dmg)

					dir=get_dir(src, target)
					castproj(Type = /obj/projectile/BurnRoses, icon_state = "fireball", damage = dmg, name = "fire ball")
					sleep(AttackDelay)

			Attacked(obj/projectile/p)
				if(p.element == GHOST || (p.icon_state == "blood" && prob(75)))
					..()
					emit(loc    = src,
						 ptype  = /obj/particle/red,
						 amount = 2,
						 angle  = new /Random(1, 359),
						 speed  = 2,
						 life   = new /Random(15,20))
				else
					emit(loc    = src,
						 ptype  = /obj/particle/green,
						 amount = 2,
						 angle  = new /Random(1, 359),
						 speed  = 2,
						 life   = new /Random(15,20))

			MapInit()
				set waitfor = 0
				..()
				alpha = rand(190,255)

				var/color1 = rgb(rand(20, 255), rand(20, 255), rand(20, 255))
				var/color2 = rgb(rand(20, 255), rand(20, 255), rand(20, 255))
				var/color3 = rgb(rand(20, 255), rand(20, 255), rand(20, 255))

				if(!isElite)
					SetSize(1 + (rand(-5,15) / 50)) // -10% to +30% size change

				animate(src, color = color1, time = 10, loop = -1)
				animate(color = color2, time = 10)
				animate(color = color3, time = 10)


			Death(mob/Player/killer)
				..()

				SpawnPet(killer, 0.1, "rand", /obj/items/wearable/pets/wisp)
				SpawnPortal(pickweight(dungeons), chance=1)


		Floating_Eye
			icon = 'Mobs.dmi'

			icon_state = "eye1"
			level = 900
			HPmodifier  = 4
			DMGmodifier = 1
			Range = 35
			var
				tmp/fired = 0
				cd = 100

			MoveDelay = 3

			Eye_of_The_Fallen
				level = 2200
				cd = 20
				HPmodifier = 50

				prizePoolSize = 3

				Range     = 50
				MoveDelay = 2
				AttackDelay = 3


				Death()
					..()

					SpawnPortal("@Hogwarts")

				MapInit()
					set waitfor = 0
					..()
					animate(src, color = rgb(255, 0, 0), time = 10, loop = -1)
					animate(color = rgb(255, 0, 255), time = 10)
					animate(color = rgb(rand(60,255), rand(60,255), rand(60,255)), time = 10)

					SetSize(3)

					namefont.QuickName(src, "The [name]", "#eee", "#e00", top=1, py=16)
					hpbar = new(src)

					origloc = null
			New()
				..()
				icon_state = "eye[rand(1,2)]"
				if(!isElite && prob(60))
					transform *= 1 + (rand(-15,30) / 50) // -30% to +60% size change

			Search()
				step_rand(src)
				for(var/mob/Player/M in ohearers(src, Range))
					if(M.loc.loc == src.loc.loc)
						target = M
						ChangeState(HOSTILE)
						break

			Death(mob/Player/killer)
				..()
				if(origloc)
					var/obj/kill_counter/count = locate("Counter_Eyes")
					if(count.add())
						Players << infomsg("The Eye of The Fallen has appeared somewhere in the desert!")
						new /mob/Enemies/Floating_Eye/Eye_of_The_Fallen (locate(rand(4,97), rand(4,97), 3))

					SpawnPet(killer, 0.1, null, /obj/items/wearable/pets/floating_eye)

			Blocked()
				density = 0
				var/turf/t = get_step_to(src, target, 1)
				if(t)
					Move(t)
				else
					..()
				density = 1

			Attack(mob/M)
				..()
				if(!fired && target && state == HOSTILE)
					fired = 1
					spawn(cd) fired = 0

					var/dmg = round(Dmg*1.5) + rand(-4,8)

					if(hardmode)
						dmg = getHardmodeDamage(dmg)

					var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
					var/tmp_d = dir
					for(var/d in dirs)
						dir = d
						castproj(icon_state = "crucio2", damage = dmg, name = "death ball", cd = 0, lag = 1)

					dir = tmp_d

					sleep(AttackDelay)

		Troll
			icon = 'Mobs.dmi'
			icon_state = "troll"
			level = 750
			HPmodifier  = 4
			MoveDelay   = 4
			AttackDelay = 3

			MapInit()
				set waitfor = 0
				..()
				if(!isElite)
					SetSize(rand(10,20) / 10)

			Attack()
				var/reset = 0
				var/p = 15
				for(var/mob/Enemies/m in orange(1, src))
					p += 20

				if(!reset && prob(p))
					Dmg        += 1200
					level       = 1000
					MoveDelay   = 2
					AttackDelay = 2
					ChangeState(state)
					reset = 1
				..()
				if(reset)
					Dmg        -= 1200
					level       = initial(level)
					MoveDelay   = initial(MoveDelay)
					AttackDelay = initial(AttackDelay)
					ChangeState(state)

			Death(mob/Player/killer)
				..()

				SpawnPet(killer, 0.1, null, /obj/items/wearable/pets/troll)
				SpawnPortal(pickweight(dungeons), chance=0.3)

			ChangeState(var/i_State)
				set waitfor = FALSE

				..(i_State)

				if(i_State == WANDER && origloc && HP > 0)
					HP = MHP
					while(state == WANDER && get_dist(loc, origloc) > 2)
						var/i = step_to(src, origloc)
						if(!i) break
						sleep(1)
		Bird_    ///SUMMONED///
			icon_state = "bird"
			level = 6

		Projectile
			var/tmp/fired = 0
			AttackDelay = 5
			MoveDelay = 5
			element = FIRE

			Fire_Bat
				icon_state = "firebat"
				level = 400

				Death(mob/Player/killer)
					..()

					SpawnPet(killer, 0.1, null, /obj/items/wearable/pets/fire_bat)

			Fire_Golem
				icon_state = "firegolem"
				level = 450

			Attack()
				if(!target || !target.loc || target.loc.loc != loc.loc || !(target in ohearers(src, Range)))
					target = null
					ShouldIBeActive()
					return

				if(!fired)
					fired = 1

					var/dmg = Dmg + rand(-4,8)

					if(hardmode)
						dmg = getHardmodeDamage(dmg)

					dir=get_dir(src, target)
					castproj(Type = /obj/projectile/BurnRoses, icon_state = "firesound", damage = dmg, name = "fire sound")
					spawn(30) fired = 0
					sleep(AttackDelay)

				var/distance = get_dist(src, target)
				if(distance > 5)
					var/turf/t = get_step_to(src, target, 1)
					if(t)
						Move(t)
					else
						target = null
						ShouldIBeActive()
				else if(distance <= 3)
					step_away(src, target)
				else if(distance > 3)
					step_rand(src)

		Archangel
			icon_state = "archangel"
			level = 500
			element = EARTH
		Water_Elemental
			icon_state = "water elemental"
			level = 550
			canBleed = FALSE
			element = WATER
		Fire_Elemental
			icon_state = "fire elemental"
			level = 600
			canBleed = FALSE
			element = FIRE
		Wyvern
			icon_state = "wyvern"
			level = 650

		Cloud
			icon_state = "cloud"
			level = 850
			canBleed = FALSE
			HPmodifier  = 4
			DMGmodifier = 1
			Range = 35

			var/tmp/fired = 0

			MapInit()
				set waitfor = 0
				..()
				alpha = rand(190,255)

				if(!isElite)
					SetSize(1 + (rand(-5,15) / 50)) // -10% to +30% size change

			Attack()
				if(!fired)
					fired = 1

					var/dmg = Dmg + rand(-4,8)

					if(hardmode)
						dmg = getHardmodeDamage(dmg)

					dir=get_dir(src, target)
					castproj(icon_state = "aqua", damage = dmg, name = "water droplet")
					spawn(30) fired = 0

				..()

			Death(mob/Player/killer)
				..()

				SpawnPet(killer, 0.1, null, /obj/items/wearable/pets/cloud)


		Flying_Book
			icon = 'Books.dmi'

			icon_state = "peace"
			level = 900
			MoveDelay = 3

			HPmodifier = 4
			DMGmodifier = 1.2

			canBleed = FALSE
			Range = 16

			var/tmp/fired = 0

			MapInit()
				set waitfor = 0
				..()

				icon_state = pick("peace", "chaos", "bank", "rmagic", "Hogwarts", "herb", "potion", "huffle", "huffleup", "key", "sword", "slyth", "slythup", "gryff", "gryffup", "raven", "ravenup")

		//		if(!isElite)
		//			SetSize(rand(10,15) / 10)

				var/obj/Shadow/s = new

				s.pixel_y = isElite ? -32 : -16
				s.appearance_flags |= RESET_TRANSFORM|PIXEL_SCALE
				var/matrix/m = matrix()
				m.Scale(isElite ? 3 : 1.5, 1)
				s.transform = m

				vis_contents += s

				m = transform
				m.Turn(90)
				animate(src, transform = m, time = 6, loop = -1)
				m.Turn(90)
				animate(transform = m, time = 6)
				m.Turn(90)
				animate(transform = m, time = 6)
				m.Turn(90)
				animate(transform = m, time = 6)


			ChangeState(var/i_State)
				set waitfor = FALSE

				..(i_State)

				if(i_State == WANDER && origloc && HP > 0)
					HP = MHP
					while(state == WANDER && get_dist(loc, origloc) > 2)
						var/i = step_to(src, origloc)
						if(!i) break
						sleep(1)

			Attack()
				if(!fired)
					fired = 1

					var/dmg = Dmg + rand(-4,8)

					if(hardmode)
						dmg = getHardmodeDamage(dmg)

					dir=get_dir(src, target)
					castproj(icon_state = pick("fireball", "quake", "aqua", "iceball", "gum"), damage = dmg, name = "spell")
					spawn(20) fired = 0

				..()
	/*		Death(mob/Player/killer)
				..()

				var/s = prob(45) ? 2 : 1
				for(var/i = 1 to s)
					new /mob/Enemies/Summoned/Snake (loc)

				SpawnPet(killer, 0.05, null, /obj/items/wearable/pets/demon_snake)*/

		Cowbook
			name = "Cownomicon"
			icon_state = "Cow"
			level = 2600
			HPmodifier = 45
			DMGmodifier = 5
			MoveDelay = 3
			AttackDelay = 1
			Range = 24
			respawnTime = 3000
			prizePoolSize = 3

			var/attempts = 3
			var/obj/Shadow/s

			ChangeState(var/i_State)
				..(i_State)

				if(state == 0 && origloc && HP > 0)
					loc = origloc

					if(attempts-- <= 0)
						attempts = initial(attempts)
						HP = MHP

			MapInit()
				set waitfor = 0
				..()
				SetSize(3)

				namefont.QuickName(src, "The [name]", "#eee", "#e00", top=1, py=16)

				hpbar = new(src)

				s = new (loc)
				s.transform = matrix() * 3

				animate(src, pixel_y = 0, time = 2, loop = -1)
				animate(pixel_y = 1, time = 2)
				animate(pixel_y = 0, time = 2)
				animate(pixel_y = -1, time = 2)


			Move(newLoc)
				if(s)
					s.glide_size = glide_size
					s.loc = newLoc
				..()

			var/tmp
				firedAvada = 0
				firedMeteor = 0
				fired = 0

			Blocked()
				density = 0
				var/turf/t = get_step_to(src, target, 1)
				if(t)
					Move(t)
				else
					..()
				density = 1

			onDamage(dmg, mob/Player/p, elem = 0, projColor=null)
				if(prob(10))
					HP += dmg
					hearers(20, src)<<"<span style=\"color:red;\"><b>[src]:</span></b> <font color=aqua>Episkey!"
					overlays+=image('attacks.dmi', icon_state = "heal")
					spawn(10)
						overlays-=image('attacks.dmi', icon_state = "heal")

				..(dmg, p, elem, projColor)

			Attack()
				..()

				if(target)

					if(!firedAvada && get_dist(src, target) <= 3)
						Avada()

					else if(!firedMeteor)
						Meteor()

					else
						var/attack = pick("fireball", "quake", "aqua", "iceball", "gum")

						var/ic
						var/attackType
						var/n
						if(prob(10))
							n = "Bombarda"
							ic = "bombarda"
							attackType = /obj/projectile/Bomb
						else
							attackType = /obj/projectile

						if(prob(5))
							var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
							for(var/di in dirs)
								castproj(Type = attackType, icon_state = ic ? ic : "fireball", damage = Dmg, name = n ? n : "Incindia", cd = 0, lag = 1, Dir=di)
						else
							dir=get_dir(src, target)
							castproj(Type = attackType, icon_state = ic ? ic : attack, damage = Dmg, name = n ? n : "Spell")


			proc/Avada()
				set waitfor = 0

				firedAvada = 1

				var/vector/start = new (x        * world.icon_size + world.icon_size / 2, y        * world.icon_size + world.icon_size / 2)
				var/vector/dest  = new (target.x * world.icon_size + world.icon_size / 2, target.y * world.icon_size + world.icon_size / 2)

				start.X += (EAST & dir) ? 7 : -7
				start.Y -= 6

				var/bolt/boltFix/b = new(start, dest, 35)

				var/c = "#30ff30"

				b.Draw(z, /obj/segment/segmentFix, color = c, thickness = 1)

				light(b.lastCreatedBolt, 3, 10, "circle", c)

				emit(loc    = target.loc,
					 ptype  = /obj/particle/smoke/proj,
				     amount = 28,
				     angle  = new /Random(0, 360),
				     speed  = 2,
				     life   = new /Random(20,35),
				     color  = c)

				target.onDamage(target.MHP * 0.4, src)
				target.Death_Check(src)

				sleep(50)
				firedAvada = 0

			proc/Meteor()
				set waitfor = 0

				firedMeteor = 1

				var/obj/boss/death/d = new (target.loc, src, pick(3,5,7))
				d.density = 1
				for(var/i = 1 to rand(0,4))
					step_away(d, src)
				d.density = 0

				sleep(20)
				firedMeteor = 0


			Kill(mob/Player/p)
				set waitfor = 0
				..(p)

				sleep(1)

				var/hudobj/teleport/t = new (null, p.client, null, show=1)
				t.dest = "teleportPointForbidden Library"
				p << errormsg("Click the teleport stone on screen button at the bottom right to go back to the snake dungeon.")



			Death(mob/Player/killer)
				set waitfor = 0
				..(killer)

				SpawnPortal("teleportPointForbidden Library", timer=1)

		Basilisk
			icon = 'Mobs.dmi'
			icon_state = "basilisk"
			level = 2000
			HPmodifier = 20
			DMGmodifier = 3
			MoveDelay = 3
			AttackDelay = 3
			Range = 24
			respawnTime = 3000

			prizePoolSize = 3

			var/attempts = 3

			ChangeState(var/i_State)
				..(i_State)

				if(state == 0 && origloc && HP > 0)
					loc = origloc

					if(attempts-- <= 0)
						attempts = initial(attempts)
						HP = MHP

			MapInit()
				set waitfor = 0
				..()
				SetSize(2)

				namefont.QuickName(src, "The [name]", "#eee", "#e00", top=1, py=16)

				hpbar = new(src)

			var/tmp/fired = 0

			Blocked()
				density = 0
				var/turf/t = get_step_to(src, target, 1)
				if(t)
					Move(t)
				else
					..()
				density = 1

			Attack()
				..()

				if(!fired && target)

					fired = 1
					spawn()

						var/obj/warnWidth  = new /obj/custom { icon = 'dot.dmi'; icon_state = "circle"; color = "#8A0707"; alpha = 20; appearance_flags = PIXEL_SCALE; } (loc)
						var/obj/warnHeight = new /obj/custom { icon = 'dot.dmi'; icon_state = "circle"; color = "#8A0707"; alpha = 20; appearance_flags = PIXEL_SCALE; } (loc)

						walk_towards(warnWidth, src)
						walk_towards(warnHeight, src)

						var/matrix/mWidth = matrix()
						mWidth.Scale(17,1)

						var/matrix/mHeight = matrix()
						mHeight.Scale(1,17)

						animate(warnWidth,  alpha = 100, transform = mWidth, time = 7)
						animate(warnHeight, alpha = 100, transform = mHeight, time = 7)

						sleep(30)

						walk(warnWidth, 0)
						warnWidth.loc = null

						walk(warnHeight, 0)
						warnHeight.loc = null

						for(var/mob/Player/p in ohearers(8, src))
							if(p.x == x || p.y == y)
								p.ApplyEffect("stone")


						sleep(rand(50,150))
						fired = 0


			Kill(mob/Player/p)
				set waitfor = 0
				..(p)

				sleep(1)

				var/hudobj/teleport/t = new (null, p.client, null, show=1)
				t.dest = "CoSBasOut"
				p << errormsg("Click the teleport stone on screen button at the bottom right to go back to the Basilisk.")



			Death(mob/Player/killer)
				..(killer)

				SpawnPortal("CoSFloor2", "CoSLockDoor", timer=1)

