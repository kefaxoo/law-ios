//
//  PDFManager.swift
//  law
//
//  Created by Bahdan Piatrouski on 19.02.25.
//

import Foundation
import PDFKit

final class PDFManager {
    struct PDFMetadata {
        let creator: String
        let title: String
    }
    
    static func createPDFData(
        metadata: PDFMetadata,
        title: String,
        textCompletion: ((
            _ context: UIGraphicsPDFRendererContext,
            _ cursorY: CGFloat,
            _ pdfSize: CGSize
        ) -> Void)? = nil
    ) -> Data {
        let metadata = [
            kCGPDFContextCreator: metadata.creator,
            kCGPDFContextAuthor: metadata.creator,
            kCGPDFContextTitle: metadata.title
        ] as [String: Any]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = metadata
        
        let rect = CGRect(x: 10, y: 10, width: 595.2, height: 841.8)
        let render = UIGraphicsPDFRenderer(bounds: rect, format: format)
        
        let data = render.pdfData { context in
            context.beginPage()
            
            let initialCursor: CGFloat = 32
            
            var cursor = context.addCenteredText(
                fontSize: 32,
                weight: .bold,
                text: title,
                cursor: initialCursor,
                pdfSize: rect.size
            )
            
            cursor += 42
            
            textCompletion?(context, cursor, rect.size)
        }
        
        return data
    }
}
