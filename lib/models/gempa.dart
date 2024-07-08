import 'dart:convert';

GempaTerkini gempaTerkiniFromJson(String str) => GempaTerkini.fromJson(json.decode(str));

String gempaTerkiniToJson(GempaTerkini data) => json.encode(data.toJson());

class GempaTerkini {
    String type;
    Metadata metadata;
    List<Feature> features;

    GempaTerkini({
        required this.type,
        required this.metadata,
        required this.features,
    });

    factory GempaTerkini.fromJson(Map<String, dynamic> json) => GempaTerkini(
        type: json["type"],
        metadata: Metadata.fromJson(json["metadata"]),
        features: List<Feature>.from(json["features"].map((x) => Feature.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "metadata": metadata.toJson(),
        "features": List<dynamic>.from(features.map((x) => x.toJson())),
    };
}

class Feature {
    String type;
    Properties properties;
    Geometry geometry;
    String id;

    Feature({
        required this.type,
        required this.properties,
        required this.geometry,
        required this.id,
    });

    factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        type: json["type"],
        properties: Properties.fromJson(json["properties"]),
        geometry: Geometry.fromJson(json["geometry"]),
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "properties": properties.toJson(),
        "geometry": geometry.toJson(),
        "id": id,
    };
}

class Geometry {
    String type;
    List<double> coordinates;

    Geometry({
        required this.type,
        required this.coordinates,
    });

    factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        type: json["type"],
        coordinates: List<double>.from(json["coordinates"].map((x) => x?.toDouble())),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
    };
}

class Properties {
    double mag;
    String place;
    int time;
    int updated;
    dynamic tz;
    String url;
    String detail;
    dynamic felt;
    dynamic cdi;
    dynamic mmi;
    dynamic alert;
    String status;
    int tsunami;
    int sig;
    String net;
    String code;
    String ids;
    String sources;
    String types;
    int nst;
    double dmin;
    double rms;
    int gap;
    String magType;
    String type;
    String title;

    Properties({
        required this.mag,
        required this.place,
        required this.time,
        required this.updated,
        required this.tz,
        required this.url,
        required this.detail,
        required this.felt,
        required this.cdi,
        required this.mmi,
        required this.alert,
        required this.status,
        required this.tsunami,
        required this.sig,
        required this.net,
        required this.code,
        required this.ids,
        required this.sources,
        required this.types,
        required this.nst,
        required this.dmin,
        required this.rms,
        required this.gap,
        required this.magType,
        required this.type,
        required this.title,
    });

    factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        mag: json["mag"]?.toDouble(),
        place: json["place"],
        time: json["time"],
        updated: json["updated"],
        tz: json["tz"],
        url: json["url"],
        detail: json["detail"],
        felt: json["felt"],
        cdi: json["cdi"],
        mmi: json["mmi"],
        alert: json["alert"],
        status: json["status"],
        tsunami: json["tsunami"],
        sig: json["sig"],
        net: json["net"],
        code: json["code"],
        ids: json["ids"],
        sources: json["sources"],
        types: json["types"],
        nst: json["nst"],
        dmin: json["dmin"]?.toDouble(),
        rms: json["rms"]?.toDouble(),
        gap: json["gap"],
        magType: json["magType"],
        type: json["type"],
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "mag": mag,
        "place": place,
        "time": time,
        "updated": updated,
        "tz": tz,
        "url": url,
        "detail": detail,
        "felt": felt,
        "cdi": cdi,
        "mmi": mmi,
        "alert": alert,
        "status": status,
        "tsunami": tsunami,
        "sig": sig,
        "net": net,
        "code": code,
        "ids": ids,
        "sources": sources,
        "types": types,
        "nst": nst,
        "dmin": dmin,
        "rms": rms,
        "gap": gap,
        "magType": magType,
        "type": type,
        "title": title,
    };
}

class Metadata {
    int generated;
    String url;
    String title;
    int status;
    String api;
    int limit;
    int offset;
    int count;

    Metadata({
        required this.generated,
        required this.url,
        required this.title,
        required this.status,
        required this.api,
        required this.limit,
        required this.offset,
        required this.count,
    });

    factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        generated: json["generated"],
        url: json["url"],
        title: json["title"],
        status: json["status"],
        api: json["api"],
        limit: json["limit"],
        offset: json["offset"],
        count: json["count"],
    );

    Map<String, dynamic> toJson() => {
        "generated": generated,
        "url": url,
        "title": title,
        "status": status,
        "api": api,
        "limit": limit,
        "offset": offset,
        "count": count,
    };
}
