/* * hexagon framework - Multi-Purpose ActionScript 3 Framework. * Copyright (C) 2007 Hexagon Star Softworks *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/ FRAMEWORK_/ *            \__/  \__/ * * ``The contents of this file are subject to the Mozilla Public License * Version 1.1 (the "License"); you may not use this file except in * compliance with the License. You may obtain a copy of the License at * http://www.mozilla.org/MPL/ * * Software distributed under the License is distributed on an "AS IS" * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the * License for the specific language governing rights and limitations * under the License. */package com.hexagonstar.data.structures{	/**	 * The NullIterator is used to write classes that are iterable and adhere	 * to an iterable interface but that don't actually have any collection data.	 * 	 * <p>An example for the use of a NullIterator is the leaf element of a	 * composite object in the Composite Pattern. In such cases it's necessary	 * that the leaf elements (which are containing no collection data) and the	 * composite elements (that do contain collection data) implement the same	 * interface and be treated in the same way. For recursive traversal purposes,	 * it's necessary  that the interface provides access to an iterator for both	 * composite and leaf elements.	 */	public class NullIterator implements IIterator	{		////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new NullIterator instance.		 */		public function NullIterator()		{		}						/**		 * Does nothing. The NullIterator can't remove any elements.		 */		public function remove():*		{			return undefined;		}						/**		 * Does nothing. The NullIterator can't be resetted.		 */		public function reset():void		{		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Returns false, regardless of the underlying data structure's condition.		 * 		 * @return false.		 */		public function get hasNext():Boolean		{			return false;		}						/**		 * Returns undefined, regardless of the underlying data structure's condition.		 * 		 * @return undefined.		 */		public function get next():*		{			return undefined;		}	}}