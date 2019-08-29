//
//  Tile.swift
//  2048 Battle
//
//  Created by James Jackson on 6/25/17.
//  Copyright © 2017 James Jackson. All rights reserved.
//

import SpriteKit

// MARK: - TileState
// Model / State Machine
enum TileState {
    
    case number(TileRelationship)
    
    mutating func next() {
        let oldTR = getNumberValue()
        let newValue = oldTR.value != 0 ? oldTR.value * 2 : (arc4random_uniform(10) < 9 ? 2 : 4)
        let newTR = TileRelationship(tile: oldTR.tile, value: newValue)
        self = .number(newTR)
        newTR.notify()
    }
    
    mutating func clear() {
        let newTR = TileRelationship(tile: getNumberValue().tile, value: 0)
        self = .number(newTR)
        newTR.notify()
    }
    
    func getNumberValue() -> TileRelationship {
        switch self {
        case let .number(value):
            return value
        }
    }
}


// MARK: - TileRelationship
// Helper
struct TileRelationship {
    let tile: TileDelegate // View

    let value: Int
    
    func notify() {
        tile.updateLabel(value)
    }
}


// MARK: - TileDelegate
protocol TileDelegate {
    func updateLabel(_ value: Int)
}


// MARK: - TILE
class Tile: SKShapeNode, TileDelegate {
    
    var state: TileState!
    let label = SKLabelNode(fontNamed: Config.defaultConfig.TILE_FONT_NAME)

    fileprivate let config = Config.defaultConfig
    
    /** Constructor */
    required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    /** Constructor */
    override init() {
        super.init()
        // configure the form and size
        let halfSize = config.TILE_SIZE / 2
        let nodeRect = CGRect(x: -halfSize, y: -halfSize, width: config.TILE_SIZE, height: config.TILE_SIZE);
        self.path = CGPath(roundedRect: nodeRect, cornerWidth: config.CORNER_RADIUS, cornerHeight: config.CORNER_RADIUS, transform: nil)
        self.addChild(label)
        // init Model
        state = TileState.number(TileRelationship(tile: self, value: 0))
        state.getNumberValue().notify()
    }
    
    /** update cell values */
    func updateLabel(_ value: Int) {
        if value > 2048 {
            self.fillColor = UIColor(hex: config.TILE_PARAMS[10000]!.tileColor)
            self.strokeColor = self.fillColor
                label.fontName = config.TILE_FONT_NAME
                label.fontSize = CGFloat(config.TILE_PARAMS[10000]!.fontSize)
                label.fontColor = UIColor(hex: config.TILE_PARAMS[10000]!.fontColor)
                label.text = String(value)
                label.position = CGPoint(x: 0, y: -label.frame.height / 2)
        } else {
            self.fillColor = UIColor(hex: config.TILE_PARAMS[value]!.tileColor)
            self.strokeColor = self.fillColor
            if value != 0 {
                label.fontName = config.TILE_FONT_NAME
                label.fontSize = CGFloat(config.TILE_PARAMS[value]!.fontSize)
                label.fontColor = UIColor(hex: config.TILE_PARAMS[value]!.fontColor)
                label.text = String(value)
                label.position = CGPoint(x: 0, y: -label.frame.height / 2)
            } else {
                label.text = ""
            }
        }
    }
}
