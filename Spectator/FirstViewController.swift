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
            return;
            if let games = res.results {
                for game in games {
                    print(game.name)
                }
                print(games[3])
                test.streamsForGame(game: games[3]) { res in
                    if let streams = res.results {
                        test.getStreamsForChannel(streams[0].channel) { res in
                            guard let results = res.results else {
                                print(res.error!)
                                return
                            }
                            print(results.filter({$0.quality == "chunked"}))
                            switch res {
                            case .success(let mike):
                                if let url = mike.filter( {$0.quality == "chunked"} ).first {
                                    //print(url)
                                    //print(Thread.isMainThread)
                                }
                            default:
                                print()
                            }
                            
                        }
                    }
                }
            }
        }
        
        test.getTopGames(100, offset: 0) { res in
            guard let games = res.results else {
                return print("failed to get offset")
            }
            if games.count == 0 {
                print("reached the end")
            }
            for game in games {
                print(game.name)
                print(game.box(.Large))
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("View about to appear")
    }


}

