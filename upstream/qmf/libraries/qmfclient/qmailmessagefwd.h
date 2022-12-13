/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt Messaging Framework.
**
** $QT_BEGIN_LICENSE:LGPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.  For licensing terms and
** conditions see http://qt.digia.com/licensing.  For further information
** use the contact form at http://qt.digia.com/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Digia gives you certain additional
** rights.  These rights are described in the Digia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3.0 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU General Public License version 3.0 requirements will be
** met: http://www.gnu.org/copyleft/gpl.html.
**
**
** $QT_END_LICENSE$
**
****************************************************************************/

#ifndef QMAILMESSAGEFWD_H
#define QMAILMESSAGEFWD_H

#include "qmailglobal.h"
#include <QPair>

class QMailMessageHeaderField;

class QMF_EXPORT QMailMessageHeaderFieldFwd
{
public:
    enum FieldType
    {
        StructuredField = 1,
        UnstructuredField = 2
    };
};

class QMailMessageContentDisposition;

class QMF_EXPORT QMailMessageContentDispositionFwd
{
public:
    enum DispositionType
    {
        None = 0,
        Inline = 1,
        Attachment = 2
    };
};

class QMailMessageBody;

class QMF_EXPORT QMailMessageBodyFwd
{
public:
    enum TransferEncoding 
    {
        NoEncoding = 0,
        SevenBit = 1, 
        EightBit = 2, 
        Base64 = 3,
        QuotedPrintable = 4,
        Binary = 5
    };

    enum EncodingStatus
    {
        AlreadyEncoded = 1,
        RequiresEncoding = 2
    };

    enum EncodingFormat
    {
        None = 0,
        Encoded = 1,
        Decoded = 2
    };
};

class QMailMessagePartContainer;

class QMF_EXPORT QMailMessagePartContainerFwd
{
public:
    enum MultipartType 
    {
        MultipartNone = 0,
        MultipartSigned = 1,
        MultipartEncrypted = 2,
        MultipartMixed = 3,
        MultipartAlternative = 4,
        MultipartDigest = 5,
        MultipartParallel = 6,
        MultipartRelated = 7,
        MultipartFormData = 8,
        MultipartReport = 9
    };
};

class QMailMessagePart;

class QMF_EXPORT QMailMessagePartFwd
{
public:
    enum ReferenceType {
        None = 0,
        MessageReference,
        PartReference
    };
};
        
class QMailMessageMetaData;

class QMF_EXPORT QMailMessageMetaDataFwd
{
public:
    enum MessageType
    {
        Mms     = 0x1,
        // was: Ems = 0x2
        Sms     = 0x4,
        Email   = 0x8,
        System  = 0x10,
        Instant = 0x20,
        None    = 0,
        AnyType = Mms | Sms | Email | System | Instant
    };

    enum ContentType {
        UnknownContent        = 0,
        NoContent             = 1,
        PlainTextContent      = 2,
        RichTextContent       = 3,
        HtmlContent           = 4,
        ImageContent          = 5,
        AudioContent          = 6,
        VideoContent          = 7,
        MultipartContent      = 8,
        SmilContent           = 9,
        VoicemailContent      = 10,
        VideomailContent      = 11,
        VCardContent          = 12,
        VCalendarContent      = 13,
        ICalendarContent      = 14,
        DeliveryReportContent = 15,
        UserContent           = 64
    };

    enum ResponseType {
        NoResponse          = 0,
        Reply               = 1, 
        ReplyToAll          = 2,
        Forward             = 3,
        ForwardPart         = 4,
        Redirect            = 5,
        UnspecifiedResponse = 6
    };
};

class QMailMessage;

class QMF_EXPORT QMailMessageFwd
{
public:
    enum AttachmentsAction {
        LinkToAttachments = 0,
        CopyAttachments,
        CopyAndDeleteAttachments
    };

    enum EncodingFormat {
        HeaderOnlyFormat = 1,
        StorageFormat = 2,
        TransmissionFormat = 3,
        IdentityFormat = 4
    }; 

    enum ChunkType {
        Text = 0,
        Reference
    };

    typedef QPair<ChunkType, QByteArray> MessageChunk;
};

#endif
