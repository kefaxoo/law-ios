//
//  UIGraphicsPDFRenderContext+Ext.swift
//  law
//
//  Created by Bahdan Piatrouski on 19.02.25.
//

import PDFKit

extension UIGraphicsPDFRendererContext {
    func addCenteredText(
        fontSize: CGFloat,
        weight: UIFont.Weight,
        text: String,
        cursor: CGFloat,
        pdfSize: CGSize
    ) -> CGFloat {
        
        let textFont = UIFont.systemFont(ofSize: fontSize, weight: weight)
        let pdfText = NSAttributedString(
            string: text,
            attributes: [NSAttributedString.Key.font: textFont]
        )
        
        let rect = CGRect(
            x: pdfSize.width / 2 - pdfText.size().width / 2,
            y: cursor,
            width: pdfText.size().width,
            height: pdfText.size().height
        )
        
        pdfText.draw(in: rect)
        
        return self.checkContext(cursor: rect.origin.y + rect.size.height, pdfSize: pdfSize)
    }
    
    func addSingleLineText(
        fontSize: CGFloat,
        weight: UIFont.Weight,
        text: String,
        indent: CGFloat,
        cursor: CGFloat,
        pdfSize: CGSize,
        annotation: PDFAnnotationSubtype?,
        annotationColor: UIColor?
    ) -> CGFloat {
        
        let textFont = UIFont.systemFont(ofSize: fontSize, weight: weight)
        let pdfText = NSAttributedString(
            string: text,
            attributes: [NSAttributedString.Key.font: textFont]
        )
        
        let rect = CGRect(
            x: indent,
            y: cursor,
            width: pdfSize.width - 2 * indent,
            height: pdfText.size().height
        )
        
        pdfText.draw(in: rect)
        
        if let annotation {
            let annotation = PDFAnnotation(
                bounds: CGRect.init(
                    x: indent, y: rect.origin.y + rect.size.height,
                    width: pdfText.size().width,
                    height: 10
                ),
                forType: annotation,
                withProperties: nil)
            annotation.color = annotationColor ?? .black
            annotation.draw(with: PDFDisplayBox.artBox, in: self.cgContext)
        }
        
        return self.checkContext(cursor: rect.origin.y + rect.size.height, pdfSize: pdfSize)
    }
    
    func addMultiLineText(
        fontSize: CGFloat,
        weight: UIFont.Weight,
        text: String,
        indent: CGFloat,
        cursor: CGFloat,
        pdfSize: CGSize
    ) -> CGFloat {
        
        let textFont = UIFont.systemFont(ofSize: fontSize, weight: weight)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .natural
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let pdfText = NSAttributedString(
            string: text,
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: textFont
            ]
        )
        
        let pdfTextHeight = pdfText.height(withConstrainedWidth: pdfSize.width - 2 * indent)
        
        let rect = CGRect(
            x: indent,
            y: cursor,
            width: pdfSize.width - 2 * indent,
            height: pdfTextHeight
        )
        
        pdfText.draw(in: rect)
        
        return self.checkContext(cursor: rect.origin.y + rect.size.height, pdfSize: pdfSize)
    }
    
    func checkContext(cursor: CGFloat, pdfSize: CGSize) -> CGFloat {
        guard cursor > pdfSize.height - 100 else { return cursor }
        
        self.beginPage()
        return 40
    }
}
