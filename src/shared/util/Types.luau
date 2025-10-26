--!strict

local Types = {}

-------------------------
-- Services
-------------------------

export type FieldService = {
	-- Properties
	fields: { [string]: any },
	generator: FieldGenerator,
	flowerCollection: FlowerCollection,
	playerService: PlayerService,

	-- Methods
	new: () -> FieldService,
	getInstance: () -> FieldService,
	start: (self: FieldService) -> FieldService,
	update: (self: FieldService, dt: number) -> (),
	getField: (self: FieldService, fieldId: string) -> any,
	setField: (self: FieldService, fieldId: string, fieldData: any) -> (),
	setFields: (self: FieldService, fieldsData: { [string]: any }) -> (),
	getPlayerField: (self: FieldService, player: Player) -> any,
}

export type PlayerService = {
	-- Define properties and methods of PlayerService here
	fieldService: FieldService,
	toolService: ToolService,

	playerEntities: { [number]: PlayerEntity },

	new: () -> PlayerService,
	start: (self: PlayerService) -> PlayerService,
	getInstance: () -> PlayerService,
	onPlayerAdded: (self: PlayerService, player: Player) -> (),
	onPlayerRemoving: (self: PlayerService, player: Player) -> (),
	update: (self: PlayerService, dt: number) -> (),
	getPlayerEntity: (self: PlayerService, player: Player) -> PlayerEntity,
}

export type ToolService = {
	-- Define properties and methods of ToolService here
	fieldService: FieldService,
	playerService: PlayerService,

	new: () -> ToolService,
	getInstance: () -> ToolService,
	start: (self: ToolService) -> ToolService,
	playerTools: { [number]: PlayerTool },
	onPlayerAdded: (self: ToolService, player: Player) -> (),
	equip: (self: ToolService, player: Player, toolId: string) -> (),
	toolUsedCallback: (self: ToolService, player: Player) -> (),
}

-------------------------
-- Field
-------------------------
export type FieldGenerator = {
	new: () -> FieldGenerator,
	getInstance: () -> FieldGenerator,

	generateField: (fieldData: FieldData) -> Field,
	generateFields: () -> { [string]: Field },
	generateModel: (field: Field) -> Model,
}

export type Field = {
	-- Define properties and methods of Field here
	data: FieldData,
	state: FieldState,

	model: Model?,

	new: (id: string, data: any) -> Field,
	setModel: (self: Field, model: Model) -> (),
	populate: (self: Field, flowers: { [string]: Flower }) -> (),
}

export type FieldData = {
	-- Define properties of FieldData here
	id: string,
	name: string,
	size: Vector2,
	position: Vector3,
	chance: FlowerChance,

	new: (id: string, name: string, size: Vector2, position: Vector3) -> FieldData,
}

export type FieldState = {
	-- Define properties and methods of FieldState here
	flowers: { [string]: Flower },

	new: () -> FieldState,
	getFlowerStateAt: (self: FieldState, x: number, y: number) -> (string, string),
	populate: (self: FieldState, flowers: { [string]: Flower }) -> (),
}

export type Flower = {
	-- Define properties and methods of Flower here
	color: string,
	size: string,

	new: (id: string, data: any) -> Flower,
}

export type FlowerChance = {
	-- Define properties and methods of FlowerChance here
	colors: { [string]: number },
	sizes: { [string]: number },

	new: () -> FlowerChance,
	getChance: (self: FlowerChance, flowerType: string) -> number,
}

export type FlowerCollection = {
	-- Define properties and methods of FlowerCollection here
	new: () -> FlowerCollection,
	getInstance: () -> FlowerCollection,
	start: (self: FlowerCollection) -> FlowerCollection,
	getTouchingParts: (part: BasePart) -> { BasePart },
	collect: (player: Player) -> (),
}

-------------------------
-- Player
-------------------------

export type PlayerEntity = {
	-- Define properties and methods of PlayerEntity here
	player: Player,
	character: Model?,
	collider: BasePart,
	heartbeatConnection: RBXScriptConnection?,

	start: (self: PlayerEntity) -> PlayerEntity,
	getPlayer: (self: PlayerEntity) -> Player,
	setCollider: (self: PlayerEntity, collider: BasePart) -> (),
	updateCollider: (self: PlayerEntity) -> (),
	getCollider: (self: PlayerEntity) -> BasePart,

	new: (player: Player) -> PlayerEntity,
}

export type PlayerTool = {
	player: Player,
	tool: Tool?,
	lastUsed: number?,
	useConnection: RBXScriptConnection?,
	cooldown: number,

	fieldService: FieldService,
	playerService: PlayerService,

	new: (tool: Tool) -> PlayerTool,
	equip: (self: PlayerTool, tool: Tool) -> (),
	isEquipped: (self: PlayerTool) -> boolean,
	getTool: (self: PlayerTool) -> Tool,
	setTool: (self: PlayerTool, tool: Tool) -> (),
	setLastUsed: (self: PlayerTool, timestamp: number) -> (),
	getLastUsed: (self: PlayerTool) -> number?,
	use: (self: PlayerTool) -> (),
	destroy: (self: PlayerTool) -> (),
}

-------------------------
-- Game
-------------------------

export type Game = {
	-- Define properties and methods of Game here

	fieldService: FieldService,
	toolService: ToolService,
	playerService: PlayerService,

	new: () -> Game,
	startServices: (self: Game) -> (),
	start: (self: Game) -> Game,
	run: (self: Game) -> Game,
	update: (self: Game, dt: number) -> (),
}

return Types
