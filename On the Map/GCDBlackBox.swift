//
//  GCDBlackBox.swift
//  On the Map
//
//  Created by Mario Preishuber on 29/03/16.
//  Copyright © 2016 Preishuber. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}
