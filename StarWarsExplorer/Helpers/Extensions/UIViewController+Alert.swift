//
//  UIViewController+Alert.swift
//  StarWarsExplorer
//
//  Created by Максим Скрябин on 30/11/2018.
//  Copyright © 2018 MSKR. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String?, body: String?, button: String?, actions: [UIAlertAction]?) {
        let alert = UIAlertController(title: title, message: body, preferredStyle: .alert)
        
        for action in actions ?? [] {
            alert.addAction(action)
        }
        
        if let button = button {
            let cancel = UIAlertAction(title: button, style: .cancel, handler: { _ in
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(cancel)
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertError(error: Error?, desc: String?, critical: Bool) {
        // проверка на отмену сетевого запроса
        if let error = error, (error as NSError).code == -999 {
            return
        }
        
        var body: String = desc ?? "Произошла неизвестная ошибка"
        var button: String? {
            if critical {
                return nil
            } else {
                return "Ок"
            }
        }
        if let error = error {
            body += "\nОписание ошибки: \(error.localizedDescription)"
        }
        
        showAlert(title: "Ошибка", body: body, button: button, actions: nil)
    }
    
}

