--!strict
local Types = {}

-------------------------
-- Services
-------------------------

export type FieldService = {
	-- Properties
	fields: { [string]: Field },
	generator: FieldGenerator,
	flowerCollection: FlowerCollection,
	playerService: PlayerService,
	toolService: ToolService,
	replenishConnection: RBXScriptConnection?,

	-- Methods
	new: () -> FieldService,
	getInstance: () -> FieldService,
	start: (self: FieldService) -> FieldService,
	update: (self: FieldService, dt: number) -> (),
	findRandom: (self: FieldService, fieldId: string) -> Flower?,
	getField: (self: FieldService, fieldId: string) -> Field,
	setField: (self: FieldService, fieldId: string, fieldData: FieldData) -> (),
	setFields: (self: FieldService, fieldsData: { [string]: Field }) -> (),
	getPlayerField: (self: FieldService, player: Player) -> Field?,
	collect: (self: FieldService, player: Player) -> (),
	collectFlower: (self: FieldService, player: Player, fieldId: string, flower: Flower) -> (),
	replenish: (self: FieldService) -> (),
	startReplenish: (self: FieldService) -> (),
}

export type ToolService = {
	-- Define properties and methods of ToolService here
	fieldService: FieldService,
	playerService: PlayerService,

	new: () -> ToolService,
	getInstance: () -> ToolService,
	start: (self: ToolService) -> ToolService,
	getPlayerTool: (self: ToolService, player: Player) -> PlayerTool,
	playerTools: { [number]: PlayerTool },
	onPlayerAdded: (self: ToolService, player: Player) -> (),
	onPlayerRemoving: (self: ToolService, player: Player) -> (),
	equip: (self: ToolService, player: Player, toolId: string) -> (),
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
	toReplenish: { string },

	new: (id: string, data: any) -> Field,
	setModel: (self: Field, model: Model) -> (),
	populate: (self: Field, flowers: { [string]: Flower }) -> (),
	containsPosition: (self: Field, position: Vector3) -> boolean,
	replenish: (self: Field) -> (),
	harvest: (self: Field, flowerKey: string, amount: number) -> boolean,
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
	getCount: (self: FieldState) -> number,
	getFlowerStateAt: (self: FieldState, x: number, y: number) -> (string, string),
	populate: (self: FieldState, flowers: { [string]: Flower }) -> (),
}

export type Flower = {
	-- Define properties and methods of Flower here
	color: string,
	size: string,
	harvested: number,
	occupied: boolean,
	position: Vector2,

	new: (id: string, data: any) -> Flower,
	harvest: (self: Flower, amount: number) -> boolean,
	replenish: (self: Flower, amount: number) -> (),
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
	fieldService: FieldService,
	playerService: PlayerService,

	new: () -> FlowerCollection,
	getInstance: () -> FlowerCollection,
	start: (self: FlowerCollection) -> FlowerCollection,
	getTouchingParts: (part: BasePart) -> { BasePart },
	collect: (player: Player) -> (),
}

-------------------------
-- Data
-------------------------

export type DataService = {
	-- Define properties and methods of DataService here
	profiles: { [number]: any },

	new: () -> DataService,
	start: (self: DataService) -> DataService,
	getInstance: () -> DataService,
	loadPlayerData: (self: DataService, player: Player) -> (),
	getProfile: (self: DataService, player: Player) -> any,
	getData: (self: DataService, player: Player) -> PlayerData,
	onPlayerAdded: (self: DataService, player: Player) -> (),
}

export type PlayerData = {
	-- Define properties and methods of PlayerData here
	tool: PlayerTool,
	stats: PlayerStats,

	new: (player: Player) -> PlayerData,
	default: () -> PlayerData,
	from: (raw: any) -> PlayerData,
	getStats: (self: PlayerData) -> PlayerStats,
	getTool: (self: PlayerData) -> PlayerTool,
}

-------------------------
-- Player
-------------------------

export type PlayerService = {
	-- Define properties and methods of PlayerService here
	fieldService: FieldService,
	toolService: ToolService,
	swarmService: SwarmService,
	dataService: DataService,

	playerEntities: { [number]: PlayerEntity },

	new: () -> PlayerService,
	start: (self: PlayerService) -> PlayerService,
	getInstance: () -> PlayerService,
	getPlayerData: (self: PlayerService, player: Player) -> PlayerData,
	onPlayerAdded: (self: PlayerService, player: Player) -> (),
	onPlayerRemoving: (self: PlayerService, player: Player) -> (),
	update: (self: PlayerService, dt: number) -> (),
	getPlayerEntity: (self: PlayerService, player: Player) -> PlayerEntity,
}

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
	destroy: (self: PlayerEntity) -> (),
}

export type PlayerStats = {
	-- Define properties and methods of PlayerStats here
	honey: number,
	backpack: PlayerBackpack,

	new: () -> PlayerStats,
	from: (raw: any) -> PlayerStats,
	getBackpack: (self: PlayerStats) -> PlayerBackpack,
	setHoney: (self: PlayerStats, amount: number) -> PlayerStats,
	getHoney: (self: PlayerStats) -> number,
	addHoney: (self: PlayerStats, amount: number) -> PlayerStats,
	removeHoney: (self: PlayerStats, amount: number) -> PlayerStats,
	setPollen: (self: PlayerStats, amount: number) -> PlayerStats,
	getPollen: (self: PlayerStats) -> number,
	addPollen: (self: PlayerStats, amount: number) -> PlayerStats,
	removePollen: (self: PlayerStats, amount: number) -> PlayerStats,
}

export type PlayerBackpack = {
	-- Define properties and methods of PlayerBackpack here
	pollen: number,

	new: () -> PlayerBackpack,
	from: (raw: any) -> PlayerBackpack,
	setPollen: (self: PlayerBackpack, amount: number) -> (),
	getPollen: (self: PlayerBackpack) -> number,
	addPollen: (self: PlayerBackpack, amount: number) -> (),
	removePollen: (self: PlayerBackpack, amount: number) -> (),
	getSize: (self: PlayerBackpack) -> number,
}

export type PlayerTool = {
	player: Player,
	tool: Tool?,
	toolName: string,
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
-- Bee
-------------------------

export type SwarmService = {
	-- Define properties and methods of BeeService here
	swarms: { [number]: Swarm },
	fieldService: FieldService,

	new: () -> SwarmService,
	getInstance: () -> SwarmService,
	start: (self: SwarmService) -> SwarmService,
	update: (self: SwarmService, dt: number) -> (),
	onPlayerAdded: (self: SwarmService, player: Player) -> (),
	onPlayerRemoving: (self: SwarmService, player: Player) -> (),

	addSwarm: (self: SwarmService, player: Player) -> Swarm,
	getSwarm: (self: SwarmService, player: Player) -> Swarm,
	removeSwarm: (self: SwarmService, swarm: Swarm) -> (),
}

export type Swarm = {
	-- Define properties and methods of Swarm here
	player: Player,
	fieldId: string?,
	bees: { [string]: Bee },

	fieldService: FieldService,

	new: () -> Swarm,
	addBee: (self: Swarm, beeType: string) -> (),
	removeBee: (self: Swarm, bee: Bee) -> (),
	update: (self: Swarm, dt: number) -> (),
	destroy: (self: Swarm) -> (),
	size: (self: Swarm) -> number,
}

export type Bee = {
	-- Define properties and methods of Bee here
	player: Player,
	model: Model,
	ai: BeeAI,
	type: string,
	index: number,
	name: string,
	id: string,
	swarm: Swarm,

	new: (player: Player, beeType: string, swarm: Swarm, index: number) -> Bee,
	update: (self: Bee, dt: number) -> (),
	destroy: (self: Bee) -> (),

	getFolder: (self: Bee) -> Folder,
	generateId: (self: Bee) -> string,
	loadModel: (self: Bee) -> Model,
	getId: (self: Bee) -> string,
}

export type BeeAI = {
	-- Define properties and methods of BeeAI here
	bee: Bee,
	speed: number,
	state: BeeState,
	maxDistance: number,
	maxHeight: number,
	timeInState: number,
	destination: Vector3?,
	timeOut: number,
	gatherChance: number,
	gatherDuration: number,
	changeDirection: boolean,
	restRotation: CFrame,
	harvestFieldId: string?,
	harvestFlower: Flower?,

	new: (bee: Bee) -> BeeAI,
	step: (self: BeeAI, dt: number) -> (),
	setState: (self: BeeAI, state: string) -> (),
	waitFor: (self: BeeAI, seconds: number) -> (),
	onTimeOut: (self: BeeAI) -> boolean,
	getPosAroundPlayer: (self: BeeAI) -> Vector3,
	getPlayerPos: (self: BeeAI) -> Vector3,
	isCloseToPlayer: (self: BeeAI) -> boolean,
	move: (self: BeeAI, dt: number) -> (),
	jiggle: (self: BeeAI, dt: number) -> (),
	states: {
		idle: (self: BeeAI, dt: number) -> (),
		collect: (self: BeeAI, dt: number) -> (),
		moveToCollect: (self: BeeAI, dt: number) -> (),
	},
}

export type BeeState = "idle" | "moveToCollect" | "collect"

-------------------------
-- Game
-------------------------

export type Game = {
	-- Define properties and methods of Game here

	fieldService: FieldService,
	toolService: ToolService,
	playerService: PlayerService,
	swarmService: SwarmService,
	dataService: DataService,

	new: () -> Game,
	startServices: (self: Game) -> (),
	start: (self: Game) -> Game,
	run: (self: Game) -> Game,
	update: (self: Game, dt: number) -> (),
}

return Types
