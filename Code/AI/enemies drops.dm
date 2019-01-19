/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */

var/list/drops_list = list("default" = list("0.1" = list(/obj/items/Whoopie_Cushion,
			 	                                         /obj/items/Smoke_Pellet,
			 	                                         /obj/items/Tube_of_fun)),

"legendary"          = list(/obj/items/crystal/soul,
							/obj/items/artifact,
							/obj/items/mystery_key,
						    /obj/items/wearable/orb/magic,
							/obj/items/wearable/orb/magic/greater,
                            /obj/items/wearable/ring/snowring,
					        /obj/items/wearable/ring/aetherwalker_ring,
					        /obj/items/wearable/shield/mana,
					        /obj/items/wearable/shield/slayer,
					        /obj/items/wearable/shield/selfdamage,
					        /obj/items/wearable/sword/slayer,
					        /obj/items/wearable/sword/vladmir,
					        /obj/items/wearable/sword/wolf,
					        /obj/items/wearable/sword/dragon,
					        /obj/items/wearable/sword/gold),

"Bubbles the Spider" = list(/obj/items/key/basic_key,
						    /obj/items/wearable/title/Crawler,
						    /obj/items/chest/blood_chest,
						    /obj/items/magic_stone/eye,
							/obj/items/lamps/triple_drop_rate_lamp,
							/obj/items/lamps/triple_gold_lamp),


"Willy the Whisp"	 = list(/obj/items/key/basic_key,
							/obj/items/key/wizard_key,
							/obj/items/wearable/title/Ghost,
							/obj/items/lamps/triple_drop_rate_lamp,
							/obj/items/lamps/triple_gold_lamp,
							/obj/items/wearable/afk/heart_ring),


"The Evil Snowman"	 = list(/obj/items/key/winter_key,
						    /obj/items/wearable/title/Snowflakes,
							/obj/items/lamps/triple_drop_rate_lamp,
							/obj/items/lamps/triple_gold_lamp,
							/obj/items/wearable/afk/hot_chocolate),

"Stone Golem"        = list(/obj/items/wearable/title/Earthbender,
                            /obj/items/wearable/pets/rock,
							/obj/items/chest/wigs/basic_wig_chest,
							/obj/items/chest/pet_chest,
							/obj/items/spellbook/peace,
							/obj/items/chest/wizard_chest,
							/obj/items/spellbook/gladius,
							/obj/items/lamps/triple_drop_rate_lamp,
							/obj/items/lamps/triple_gold_lamp),

"Zombie"             = list(/obj/items/wearable/scarves/halloween_scarf,
							/obj/items/key/winter_key,
							/obj/items/artifact,
							/obj/items/crystal/soul,
							/obj/items/lamps/triple_drop_rate_lamp,
							/obj/items/lamps/triple_gold_lamp,
							/obj/items/wearable/title/Undead),

"The Black Blade"     = list(/obj/items/key/wizard_key,
		                    /obj/items/key/pentakill_key,
		                    /obj/items/key/sunset_key,
							/obj/items/key/winter_key,
							/obj/items/key/pet_key,
							/obj/items/key/community_key,
                            /obj/items/wearable/pets/sword,
							/obj/items/wearable/title/Samurai,
							/obj/items/spellbook/gladius,
							/obj/items/vault_key),

"duelist"            = list("10" = list(/obj/items/key/wizard_key,
										/obj/items/artifact,
							   		    /obj/items/stickbook,
									    /obj/items/crystal/soul,
				                        /obj/items/wearable/title/Surf),
							"50" = list(/obj/items/crystal/magic,
							            /obj/items/crystal/strong_luck)),


"Rat"                = list("5"    = /obj/items/ingredients/rat_tail),
"Dog"                = list("1"    = /obj/items/ingredients/eyes),
"Wolf"               = list("2"    = /obj/items/ingredients/eyes),

"Demon Rat"          = list("10"   = list(/obj/items/demonic_essence,
                                          /obj/items/ingredients/rat_tail)),


"Snowman"            = list("0.5" = list(/obj/items/wearable/orb/peace,
							             /obj/items/wearable/orb/chaos,
							             /obj/items/wearable/orb/magic,
							             /obj/items/key/winter_key,
							             /obj/items/chest/winter_chest)),


"Wisp"               = list("0.1" = /obj/items/wearable/title/Magic,
							"0.5" = list(/obj/items/key/basic_key,
							             /obj/items/key/wizard_key,
							             /obj/items/key/pentakill_key,
							             /obj/items/key/winter_key,
							             /obj/items/key/sunset_key)),

"Vengeful Ghost"     = list("2"   = list(/obj/items/colors/purple_stone,
							 			 /obj/items/colors/pink_stone,
						     			 /obj/items/colors/teal_stone,
						     			 /obj/items/colors/orange_stone),
							"4"   = list(/obj/items/colors/red_stone,
							 			 /obj/items/colors/green_stone,
						     			 /obj/items/colors/yellow_stone,
						     			 /obj/items/colors/blue_stone),
							"8"   = list(/obj/items/wearable/orb/chaos,
							 			 /obj/items/wearable/orb/peace,
							 			 /obj/items/wearable/orb/magic)),

"Vampire Lord"       = list("10"   = list(/obj/items/colors/blood_stone,
										  /obj/items/spellbook/blood),
							"30"   = list(/obj/items/colors/purple_stone,
							 			  /obj/items/colors/pink_stone,
						     			  /obj/items/colors/teal_stone,
						     			  /obj/items/colors/orange_stone,
						     			  /obj/items/chest/wigs/basic_wig_chest),
							"40"   =      /obj/items/chest/blood_chest),


"Eye of The Fallen"  = list("10"   = list(/obj/items/wearable/pets/mad_eye,
										  /obj/items/artifact,
										  /obj/items/crystal/soul,
				                          /obj/items/wearable/title/Fallen,
				                          /obj/items/rosesbook,
				                          /obj/items/key/sunset_key),
							"55"   = list(/obj/items/crystal/magic,
							              /obj/items/crystal/strong_luck)),


"Floating Eye"       = list("0.02" =      /obj/items/wearable/title/Eye,
							"0.5"  = list(/obj/items/wearable/orb/peace,
							              /obj/items/wearable/orb/chaos,
							              /obj/items/wearable/orb/magic),
							"8"    =      /obj/items/ingredients/eyes),


"Troll"              = list("5"    = list(/obj/items/Whoopie_Cushion,
			 				  			  /obj/items/Smoke_Pellet,
			 			  				  /obj/items/Tube_of_fun),
			 			  	"10"   = list(/obj/items/bucket,
			 			  	 			  /obj/items/scroll,
			 			  	 			  /obj/items/ingredients/eyes,
			 			  	 			  /obj/items/wearable/title/Troll)),

"Acromantula"        = list("1"    = list(/obj/items/key/winter_key,
			 			  	 			  /obj/items/key/blood_key,
						     			  /obj/items/colors/yellow_stone,
						     			  /obj/items/colors/blue_stone,
						     			  /obj/items/wearable/orb/peace,
							              /obj/items/wearable/orb/chaos),
			 			  	"10"   =      /obj/items/blood_sack),


"Vampire"            = list("1"  = list(/obj/items/key/winter_key,
			 			  	 			  /obj/items/key/blood_key,
			 			  	 			  /obj/items/colors/red_stone,
							 			  /obj/items/colors/green_stone,
							 			  /obj/items/wearable/orb/peace,
							              /obj/items/wearable/orb/chaos,
							              /obj/items/wearable/orb/magic),
			 			  	"15"    = list(/obj/items/blood_sack,
			 			  	              /obj/items/reputation/chaos_tablet,
			 			  	              /obj/items/reputation/peace_tablet)),


"Basilisk"           = list("5"    = list(/obj/items/key/pentakill_key,
										  /obj/items/artifact,
										  /obj/items/wearable/title/Petrified,
										  /obj/items/crystal/soul,
										  /obj/items/wearable/orb/peace,
							              /obj/items/wearable/orb/chaos,
							              /obj/items/wearable/orb/magic),
							"45"   = list(/obj/items/crystal/magic,
						     			  /obj/items/crystal/strong_luck)),

"The Good Snowman"   = list("5"    = list(/obj/items/chest/wigs/sunset_wig_chest,
										  /obj/items/chest/wigs/chess_chest,
										  /obj/items/chest/sunset_chest,
										  /obj/items/key/chess_key,
										  /obj/items/key/pet_key,
										  /obj/items/wearable/pets/snowman,
										  /obj/items/artifact,
										  /obj/items/wearable/title/Frozen,
										  /obj/items/wearable/orb/peace,
							              /obj/items/wearable/orb/chaos,
							              /obj/items/wearable/orb/magic,
										  /obj/items/crystal/soul),
							"50"   = list(/obj/items/crystal/magic,
						     			  /obj/items/crystal/strong_luck)))



mob/Player/var/pity = 0