/*
 * Copyright (c) 2011-2012 Research In Motion Limited.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "TwitterRequest.hpp"

#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QUrl>

/*
 * Default constructor
 */
TwitterRequest::TwitterRequest(QObject *parent)
    : QObject(parent)
{
}

/*
 * TwitterRequest::requestTimeline(const QString &screenName)
 *
 * Makes a network call to retrieve the twitter feed for the specified screenname
 */
//! [0]
void TwitterRequest::requestTimeline(const QString &startDate,const QString &endDate,const QString &url,const QString &uName ,const QString &pwd)
{


	QNetworkAccessManager* netManager = new QNetworkAccessManager();
		if (!netManager) {
			//qDebug() << "Unable to create QNetworkAccessManager!";
			emit complete("Unable to create QNetworkAccessManager!", false);
			return;
		}
		QString queryUri = url;
		QUrl myOshurl(queryUri);
		myOshurl.addQueryItem("startDate",startDate);
		myOshurl.addQueryItem("endDate",endDate);
		QNetworkRequest qheader;
		QString loginData = uName+":"+pwd;
		QByteArray data = loginData.toLocal8Bit().toBase64();
		QString headerData = "Basic " + data;
		qheader.setRawHeader("Authorization", headerData.toLocal8Bit());
		qheader.setUrl(myOshurl);
		QNetworkReply* ipReply = netManager->get(qheader);
		connect(ipReply, SIGNAL(finished()), this, SLOT(onTimelineReply()));
}
//! [0]

/*
 * TwitterRequest::onTimelineReply()
 *
 * Callback handler for QNetworkReply finished() signal
 */
//! [1]
void TwitterRequest::onTimelineReply()
{
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(sender());

    QString response;
    bool success = false;
    if (reply) {
        if (reply->error() == QNetworkReply::NoError) {
            const int available = reply->bytesAvailable();
            if (available > 0) {
                const QByteArray buffer = reply->readAll();
                response = QString::fromUtf8(buffer);
                success = true;
            }
        } else {
            response =  tr("Error: %1 status: %2").arg(reply->errorString(), reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toString());
        }

        reply->deleteLater();
    }

    if (response.trimmed().isEmpty()) {
        response = tr("Request failed. Check internet connection");
    }

    emit complete(response, success);
}
//! [1]
