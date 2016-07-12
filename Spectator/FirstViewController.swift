//
//  FirstViewController.swift
//  Spectator
//
//  Created by Michael Zeller on 7/2/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let test = TwitchService()
        test.getTopGames { res in
            if let games = res.results {
                print(games[3])
                test.streamsForGame(game: games[3]) { res in
                    if let streams = res.results {
                        test.getStreamsForChannel(streams[0].channel) { res in
                            switch res {
                            case .Success(let mike):
                                if let url = mike.filter( {$0.quality == "chunked"} ).first {
                                    print(url)
                                    print(NSThread.isMainThread())
                                }
                            default:
                                print()
                            }
                            
                        }
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

