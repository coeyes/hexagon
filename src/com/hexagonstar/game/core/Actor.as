/* * hexagon framework - Multi-Purpose ActionScript 3 Framework. * Copyright (C) 2007 Hexagon Star Softworks *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/ FRAMEWORK_/ *            \__/  \__/ * * ``The contents of this file are subject to the Mozilla Public License * Version 1.1 (the "License"); you may not use this file except in * compliance with the License. You may obtain a copy of the License at * http://www.mozilla.org/MPL/ * * Software distributed under the License is distributed on an "AS IS" * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the * License for the specific language governing rights and limitations * under the License. */package com.hexagonstar.game.core{	/**	 * Generalized class for NPC, Player and Creature type objects.	 */	public class Actor extends InteractiveGameObject	{		////////////////////////////////////////////////////////////////////////////////////////		// Constants                                                                          //		////////////////////////////////////////////////////////////////////////////////////////						////////////////////////////////////////////////////////////////////////////////////////		// Variables                                                                          //		////////////////////////////////////////////////////////////////////////////////////////				protected var _inventory:Inventory;				////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new Actor instance.		 */		public function Actor()		{		}				/**		 * Returns a String Representation of Actor.		 * 		 * @return A String Representation of Actor.		 */		override public function toString():String		{			return "[Actor, id=" + _id + "]";		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				public function get inventory():Inventory		{			return _inventory;		}				public function set inventory(v:Inventory):void		{			_inventory = v;		}						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////			}}