import 'package:youtube_explode_dart/youtube_explode_dart.dart';

enum ItemType {
  artist,
  album,
  track,
  tag,
  detailArtist,
  detailAlbum,
  detailTag,
  tagPage,
  event,
}

extension ItemTypeExtension on ItemType {
  String get name {
    switch (this) {
      case ItemType.artist:
        return 'Artist';
      case ItemType.album:
        return 'Album';
      case ItemType.track:
        return 'Track';
      case ItemType.tag:
        return 'Tag';
      case ItemType.detailArtist:
        return 'DetailArtist';
      case ItemType.detailAlbum:
        return 'DetailAlbum';
      case ItemType.detailTag:
        return 'DetailTag';
      case ItemType.tagPage:
        return 'TagPage';
      case ItemType.event:
        return 'Event';
    }
  }
}

extension StringExtension on String {
  ItemType get itemType {
    switch (toLowerCase()) {
      case 'artist':
        return ItemType.artist;
      case 'album':
        return ItemType.album;
      case 'track':
        return ItemType.track;
      case 'tag':
        return ItemType.tag;
      case 'detailArtist':
        return ItemType.detailArtist;
      case 'detailAlbum':
        return ItemType.detailAlbum;
      case 'detailTag':
        return ItemType.detailTag;
      case 'tagPage':
        return ItemType.tagPage;
      case 'event':
        return ItemType.event;
      default:
        return ItemType.artist;
    }
  }
}

class BaseArtistModel {
  final String name;
  final String url;
  final String? imageUrl;
  final int? listeners;
  final String? shortDescription;
  final ItemType itemType;

  BaseArtistModel({
    required this.name,
    required this.url,
    this.imageUrl,
    this.listeners,
    this.shortDescription,
    this.itemType = ItemType.artist,
  });

  factory BaseArtistModel.fromJson(Map<String, dynamic> json) {
    return BaseArtistModel(
      name: json['name'],
      url: json['url'],
      imageUrl: json['imageUrl'],
      listeners: int.tryParse(json['listeners']),
      shortDescription: json['shortDescription'],
      itemType: json['itemType'].toString().itemType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
      'imageUrl': imageUrl,
      'listeners': listeners,
      'shortDescription': shortDescription,
      'itemType': itemType.name,
    };
  }
}

class BaseAlbumModel {
  final String name;
  final String url;
  final String artistUrl;
  final String? imageUrl;
  final String artistName;
  final ItemType itemType;
  final int? listeners;
  final DateTime? releaseDate;
  final int? numberOfTracks;

  BaseAlbumModel({
    required this.name,
    required this.url,
    required this.artistUrl,
    this.imageUrl,
    required this.artistName,
    this.listeners,
    this.releaseDate,
    this.numberOfTracks,
    this.itemType = ItemType.album,
  });

  factory BaseAlbumModel.fromJson(Map<String, dynamic> json) {
    return BaseAlbumModel(
      name: json['name'],
      url: json['url'],
      artistUrl: json['artistUrl'],
      imageUrl: json['imageUrl'],
      artistName: json['artist'],
      listeners: int.tryParse(json['listeners']),
      releaseDate: json['releaseDate'] != null
          ? DateTime.tryParse(json['releaseDate'])
          : null,
      numberOfTracks: int.tryParse(json['numberOfTracks']),
      itemType: json['itemType'].toString().itemType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
      'artistUrl': artistUrl,
      'imageUrl': imageUrl,
      'artistName': artistName,
      'listeners': listeners,
      'releaseDate': releaseDate?.toIso8601String(),
      'numberOfTracks': numberOfTracks,
      'itemType': itemType.name,
    };
  }
}

class RawSongSource {
  final String url;
  final String extractorUrl;

  RawSongSource({
    required this.url,
    required this.extractorUrl,
  });

  factory RawSongSource.fromJson(Map<String, dynamic> json) {
    return RawSongSource(
      url: json['url'],
      extractorUrl: json['extractor_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'extractorUrl': extractorUrl,
    };
  }
}

class BaseTrackModel {
  final String name;
  final int? number;
  final Duration? duration;
  final String url;
  final String artistUrl;
  final RawSongSource? source;
  final String? imageUrl;
  final String artistName;
  final String? albumName;
  final int? listeners;
  final ItemType itemType;

  BaseTrackModel({
    required this.name,
    this.number,
    this.duration,
    required this.url,
    required this.artistUrl,
    this.source,
    this.imageUrl,
    required this.artistName,
    this.albumName,
    this.listeners,
    this.itemType = ItemType.track,
  });

  factory BaseTrackModel.fromJson(Map<String, dynamic> json) {
    return BaseTrackModel(
      name: json['name'],
      number: int.tryParse(json['number']),
      duration: json['duration'] != null
          ? Duration(seconds: int.tryParse(json['duration']) ?? 0)
          : null,
      url: json['url'],
      artistUrl: json['artistUrl'],
      source: json['source'] != null
          ? RawSongSource.fromJson(json['source'])
          : null,
      imageUrl: json['imageUrl'],
      artistName: json['artistName'],
      albumName: json['albumName'],
      listeners: int.tryParse(json['listeners']),
      itemType: json['itemType'].toString().itemType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'number': number,
      'duration': duration?.inSeconds,
      'url': url,
      'artistUrl': artistUrl,
      'source': source?.toJson(),
      'imageUrl': imageUrl,
      'artistName': artistName,
      'albumName': albumName,
      'listeners': listeners,
      'itemType': itemType.name,
    };
  }
}

class SearchResultsModel {
  final List<BaseArtistModel>? artists;
  final List<BaseAlbumModel>? albums;
  final List<BaseTrackModel>? tracks;

  SearchResultsModel({
    this.artists,
    this.albums,
    this.tracks,
  });

  factory SearchResultsModel.fromJson(Map<String, dynamic> json) {
    return SearchResultsModel(
      artists: json['artists'] != null
          ? (json['artists'] as List)
              .map((e) => BaseArtistModel.fromJson(e))
              .toList()
          : null,
      albums: json['albums'] != null
          ? (json['albums'] as List)
              .map((e) => BaseAlbumModel.fromJson(e))
              .toList()
          : null,
      tracks: json['tracks'] != null
          ? (json['tracks'] as List)
              .map((e) => BaseTrackModel.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'artists': artists?.map((e) => e.toJson()).toList(),
      'albums': albums?.map((e) => e.toJson()).toList(),
      'tracks': tracks?.map((e) => e.toJson()).toList(),
    };
  }
}

class TagModel {
  final String name;
  final String url;
  final ItemType itemType;

  TagModel({
    required this.name,
    required this.url,
    this.itemType = ItemType.tag,
  });

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      name: json['name'],
      url: json['url'],
      itemType: json['itemType'].toString().itemType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
      'itemType': itemType.name,
    };
  }
}

enum ExternalLinksType {
  website,
  twitter,
  facebook,
  soundcloud,
  instagram,
  youtube,
  spotify,
  bandcamp,
  artimage,
  appleMusic,
}

extension ExternalLinksTypeExtension on ExternalLinksType {
  String get name {
    switch (this) {
      case ExternalLinksType.website:
        return 'Website';
      case ExternalLinksType.appleMusic:
        return 'Apple Music';
      case ExternalLinksType.twitter:
        return 'Twitter';
      case ExternalLinksType.facebook:
        return 'Facebook';
      case ExternalLinksType.soundcloud:
        return 'SoundCloud';
      case ExternalLinksType.instagram:
        return 'Instagram';
      case ExternalLinksType.youtube:
        return 'YouTube';
      case ExternalLinksType.spotify:
        return 'Spotify';
      case ExternalLinksType.bandcamp:
        return 'Bandcamp';
      case ExternalLinksType.artimage:
        return 'ArtImage';
      default:
        return 'Website';
    }
  }
}

extension ExternalLinksTypeStringExtension on String {
  ExternalLinksType get externalLinksType {
    switch (toLowerCase()) {
      case 'website':
        return ExternalLinksType.website;
      case 'apple music':
        return ExternalLinksType.appleMusic;
      case 'twitter':
        return ExternalLinksType.twitter;
      case 'facebook':
        return ExternalLinksType.facebook;
      case 'soundcloud':
        return ExternalLinksType.soundcloud;
      case 'instagram':
        return ExternalLinksType.instagram;
      case 'youtube':
        return ExternalLinksType.youtube;
      case 'spotify':
        return ExternalLinksType.spotify;
      case 'bandcamp':
        return ExternalLinksType.bandcamp;
      case 'artimage':
        return ExternalLinksType.artimage;
      default:
        return ExternalLinksType.website;
    }
  }
}

class ExternalLinksModel {
  final ExternalLinksType type;
  final String url;

  ExternalLinksModel({
    required this.type,
    required this.url,
  });

  factory ExternalLinksModel.fromJson(Map<String, dynamic> json) {
    return ExternalLinksModel(
      type: ExternalLinksType.values.firstWhere(
        (e) => e.toString() == 'ExternalLinksType.${json['type']}',
      ),
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'url': url,
    };
  }
}

class EventModel {
  final DateTime date;
  final String title;
  final List<String> performers;
  final String venue;
  final String address;

  EventModel({
    required this.date,
    required this.title,
    required this.performers,
    required this.venue,
    required this.address,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      date: DateTime.tryParse(json['date']) ?? DateTime.now(),
      title: json['title'],
      performers: (json['performers'] as List).cast<String>(),
      venue: json['venue'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'title': title,
      'performers': performers,
      'venue': venue,
      'address': address,
    };
  }
}

class DetailedArtistModel extends BaseArtistModel {
  final bool isTouring;
  final BaseAlbumModel? latestRelease;
  final BaseTrackModel? popularThisWeek;
  final List<BaseArtistModel> similarArtists;
  final String bio;
  final DateTime? bornWhen;
  final String? bornWhere;
  final DateTime? diedWhen;
  final List<TagModel> tags;
  final List<BaseTrackModel> topTracks;
  final String? allTracksUrl;
  final List<String> photoUrls;
  final String? morePhotosUrl;
  final List<BaseAlbumModel> albums;
  final List<ExternalLinksModel> externalLinks;
  final String? eventsUrl;

  DetailedArtistModel({
    required this.isTouring,
    required String name,
    required String url,
    required String? imageUrl,
    required int? listeners,
    ItemType itemType = ItemType.detailArtist,
    this.latestRelease,
    this.popularThisWeek,
    required this.similarArtists,
    required this.bio,
    this.bornWhen,
    this.bornWhere,
    this.diedWhen,
    required this.tags,
    required this.topTracks,
    this.allTracksUrl,
    required this.photoUrls,
    this.morePhotosUrl,
    required this.albums,
    required this.externalLinks,
    this.eventsUrl,
  }) : super(
          name: name,
          url: url,
          imageUrl: imageUrl,
          listeners: listeners,
          itemType: itemType,
        );

  factory DetailedArtistModel.fromJson(Map<String, dynamic> json) {
    return DetailedArtistModel(
      isTouring: json['isTouring'],
      name: json['name'],
      url: json['url'],
      imageUrl: json['imageUrl'],
      listeners: int.tryParse(json['listeners']),
      latestRelease: json['latestRelease'] != null
          ? BaseAlbumModel.fromJson(json['latestRelease'])
          : null,
      popularThisWeek: json['popularThisWeek'] != null
          ? BaseTrackModel.fromJson(json['popularThisWeek'])
          : null,
      similarArtists: (json['similarArtists'] as List)
          .map((e) => BaseArtistModel.fromJson(e))
          .toList(),
      bio: json['bio'],
      bornWhen:
          json['bornWhen'] != null ? DateTime.tryParse(json['bornWhen']) : null,
      bornWhere: json['bornWhere'],
      diedWhen:
          json['diedWhen'] != null ? DateTime.tryParse(json['diedWhen']) : null,
      tags: (json['tags'] as List).map((e) => TagModel.fromJson(e)).toList(),
      topTracks: (json['topTracks'] as List)
          .map((e) => BaseTrackModel.fromJson(e))
          .toList(),
      allTracksUrl: json['allTracksUrl'],
      photoUrls: (json['photoUrls'] as List).cast<String>(),
      morePhotosUrl: json['morePhotosUrl'],
      albums: (json['albums'] as List)
          .map((e) => BaseAlbumModel.fromJson(e))
          .toList(),
      externalLinks: (json['externalLinks'] as List)
          .map((e) => ExternalLinksModel.fromJson(e))
          .toList(),
      eventsUrl: json['eventsUrl'],
      itemType: json['itemType'].toString().itemType,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'isTouring': isTouring,
      'name': name,
      'url': url,
      'imageUrl': imageUrl,
      'listeners': listeners,
      'latestRelease': latestRelease?.toJson(),
      'popularThisWeek': popularThisWeek?.toJson(),
      'similarArtists': similarArtists.map((e) => e.toJson()).toList(),
      'bio': bio,
      'bornWhen': bornWhen?.toIso8601String(),
      'bornWhere': bornWhere,
      'diedWhen': diedWhen?.toIso8601String(),
      'tags': tags.map((e) => e.toJson()).toList(),
      'topTracks': topTracks.map((e) => e.toJson()).toList(),
      'allTracksUrl': allTracksUrl,
      'photoUrls': photoUrls,
      'morePhotosUrl': morePhotosUrl,
      'albums': albums.map((e) => e.toJson()).toList(),
      'externalLinks': externalLinks.map((e) => e.toJson()).toList(),
      'eventsUrl': eventsUrl,
      'itemType': itemType.name,
    };
  }
}

class DetailedAlbumModel extends BaseAlbumModel {
  final String? description;
  final Duration? duration;
  final List<BaseTrackModel> tracks;
  final List<TagModel> tags;
  final List<BaseAlbumModel> similarAlbums;
  final List<ExternalLinksModel> externalLinks;

  DetailedAlbumModel({
    required String name,
    required String url,
    required String artistUrl,
    required String? imageUrl,
    required String artistName,
    required int? listeners,
    required DateTime? releaseDate,
    required int? numberOfTracks,
    ItemType itemType = ItemType.detailAlbum,
    this.description,
    this.duration,
    required this.tracks,
    required this.tags,
    required this.similarAlbums,
    required this.externalLinks,
  }) : super(
          name: name,
          url: url,
          artistUrl: artistUrl,
          imageUrl: imageUrl,
          artistName: artistName,
          listeners: listeners,
          releaseDate: releaseDate,
          numberOfTracks: numberOfTracks,
          itemType: itemType,
        );

  factory DetailedAlbumModel.fromJson(Map<String, dynamic> json) {
    return DetailedAlbumModel(
      name: json['name'],
      url: json['url'],
      artistUrl: json['artistUrl'],
      imageUrl: json['imageUrl'],
      artistName: json['artist'],
      description: json['description'],
      listeners: int.tryParse(json['listeners']),
      numberOfTracks: int.tryParse(json['numberOfTracks']) ?? 0,
      duration: json['duration'] != null
          ? Duration(seconds: int.tryParse(json['duration']) ?? 0)
          : null,
      releaseDate: json['releaseDate'] != null
          ? DateTime.tryParse(json['releaseDate'])
          : null,
      tracks: (json['tracks'] as List)
          .map((e) => BaseTrackModel.fromJson(e))
          .toList(),
      tags: (json['tags'] as List).map((e) => TagModel.fromJson(e)).toList(),
      similarAlbums: (json['similarAlbums'] as List)
          .map((e) => BaseAlbumModel.fromJson(e))
          .toList(),
      externalLinks: (json['externalLinks'] as List)
          .map((e) => ExternalLinksModel.fromJson(e))
          .toList(),
      itemType: json['itemType'].toString().itemType,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
      'artistUrl': artistUrl,
      'imageUrl': imageUrl,
      'artistName': artistName,
      'description': description,
      'listeners': listeners,
      'numberOfTracks': numberOfTracks,
      'duration': duration?.inSeconds,
      'releaseDate': releaseDate?.toIso8601String(),
      'tracks': tracks.map((e) => e.toJson()).toList(),
      'tags': tags.map((e) => e.toJson()).toList(),
      'similarAlbums': similarAlbums.map((e) => e.toJson()).toList(),
      'externalLinks': externalLinks.map((e) => e.toJson()).toList(),
      'itemType': itemType.name,
    };
  }
}

class DetailedTrackModel extends BaseTrackModel {
  final String description;
  final List<TagModel> tags;
  final String? lyricsUrl;
  final List<BaseAlbumModel> featuredOnAlbums;
  final List<BaseTrackModel> similarTracks;
  final List<ExternalLinksModel> playLinks;
  final List<ExternalLinksModel> externalLinks;
  final List<BaseArtistModel> similarArtists;

  DetailedTrackModel({
    required String name,
    int? number,
    Duration? duration,
    required String url,
    required String artistUrl,
    RawSongSource? source,
    String? imageUrl,
    required String artistName,
    String? albumName,
    int? listeners,
    required this.description,
    this.tags = const [],
    this.lyricsUrl,
    this.featuredOnAlbums = const [],
    this.similarTracks = const [],
    this.playLinks = const [],
    this.externalLinks = const [],
    this.similarArtists = const [],
  }) : super(
          name: name,
          number: number,
          duration: duration,
          url: url,
          artistUrl: artistUrl,
          source: source,
          imageUrl: imageUrl,
          artistName: artistName,
          albumName: albumName,
          listeners: listeners,
        );

  factory DetailedTrackModel.fromJson(Map<String, dynamic> json) {
    return DetailedTrackModel(
      name: json['name'],
      number: int.tryParse(json['number']),
      duration: json['duration'] != null
          ? Duration(seconds: int.tryParse(json['duration']) ?? 0)
          : null,
      url: json['url'],
      artistUrl: json['artistUrl'],
      source: json['source'] != null
          ? RawSongSource.fromJson(json['source'])
          : null,
      imageUrl: json['imageUrl'],
      artistName: json['artistName'],
      albumName: json['albumName'],
      listeners: int.tryParse(json['listeners']),
      description: json['description'],
      tags: (json['tags'] as List).map((e) => TagModel.fromJson(e)).toList(),
      lyricsUrl: json['lyricsUrl'],
      featuredOnAlbums: (json['featuredOnAlbums'] as List)
          .map((e) => BaseAlbumModel.fromJson(e))
          .toList(),
      similarTracks: (json['similarTracks'] as List)
          .map((e) => BaseTrackModel.fromJson(e))
          .toList(),
      playLinks: (json['playLinks'] as List)
          .map((e) => ExternalLinksModel.fromJson(e))
          .toList(),
      externalLinks: (json['externalLinks'] as List)
          .map((e) => ExternalLinksModel.fromJson(e))
          .toList(),
      similarArtists: (json['similarArtists'] as List)
          .map((e) => BaseArtistModel.fromJson(e))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'number': number,
      'duration': duration?.inSeconds,
      'url': url,
      'artistUrl': artistUrl,
      'source': source?.toJson(),
      'imageUrl': imageUrl,
      'artistName': artistName,
      'albumName': albumName,
      'listeners': listeners,
      'description': description,
      'tags': tags.map((e) => e.toJson()).toList(),
      'lyricsUrl': lyricsUrl,
      'featuredOnAlbums': featuredOnAlbums.map((e) => e.toJson()).toList(),
      'similarTracks': similarTracks.map((e) => e.toJson()).toList(),
      'playLinks': playLinks.map((e) => e.toJson()).toList(),
      'externalLinks': externalLinks.map((e) => e.toJson()).toList(),
      'similarArtists': similarArtists.map((e) => e.toJson()).toList(),
    };
  }
}

class DetailedTagModel extends TagModel {
  final String? imageUrl;

  DetailedTagModel({
    required String name,
    required String url,
    ItemType itemType = ItemType.detailTag,
    this.imageUrl,
  }) : super(
          name: name,
          url: url,
          itemType: itemType,
        );

  factory DetailedTagModel.fromJson(Map<String, dynamic> json) {
    return DetailedTagModel(
      name: json['name'],
      url: json['url'],
      imageUrl: json['imageUrl'],
      itemType: json['itemType'].toString().itemType,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
      'imageUrl': imageUrl,
      'itemType': itemType.name,
    };
  }
}

class TagPageModel extends TagModel {
  final String? imageUrl;
  final List<TagModel> similarTags;
  final String description;
  final List<BaseArtistModel> topArtists;
  final String? moreArtistsUrl;
  final List<BaseAlbumModel> topAlbums;
  final String? moreAlbumsUrl;
  final List<BaseTrackModel> topTracks;
  final String? moreTracksUrl;
  final List<DetailedTagModel> relatedTags;

  TagPageModel({
    required String name,
    required String url,
    ItemType itemType = ItemType.tagPage,
    this.imageUrl,
    required this.similarTags,
    required this.description,
    required this.topArtists,
    this.moreArtistsUrl,
    required this.topAlbums,
    this.moreAlbumsUrl,
    required this.topTracks,
    this.moreTracksUrl,
    required this.relatedTags,
  }) : super(
          name: name,
          url: url,
          itemType: itemType,
        );

  factory TagPageModel.fromJson(Map<String, dynamic> json) {
    return TagPageModel(
      name: json['name'],
      url: json['url'],
      imageUrl: json['imageUrl'],
      similarTags: (json['similarTags'] as List)
          .map((e) => TagModel.fromJson(e))
          .toList(),
      description: json['description'],
      topArtists: (json['topArtists'] as List)
          .map((e) => BaseArtistModel.fromJson(e))
          .toList(),
      moreArtistsUrl: json['moreArtistsUrl'],
      topAlbums: (json['topAlbums'] as List)
          .map((e) => BaseAlbumModel.fromJson(e))
          .toList(),
      moreAlbumsUrl: json['moreAlbumsUrl'],
      topTracks: (json['topTracks'] as List)
          .map((e) => BaseTrackModel.fromJson(e))
          .toList(),
      moreTracksUrl: json['moreTracksUrl'],
      relatedTags: (json['relatedTags'] as List)
          .map((e) => DetailedTagModel.fromJson(e))
          .toList(),
      itemType: json['itemType'].toString().itemType,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
      'imageUrl': imageUrl,
      'similarTags': similarTags.map((e) => e.toJson()).toList(),
      'description': description,
      'topArtists': topArtists.map((e) => e.toJson()).toList(),
      'moreArtistsUrl': moreArtistsUrl,
      'topAlbums': topAlbums.map((e) => e.toJson()).toList(),
      'moreAlbumsUrl': moreAlbumsUrl,
      'topTracks': topTracks.map((e) => e.toJson()).toList(),
      'moreTracksUrl': moreTracksUrl,
      'relatedTags': relatedTags.map((e) => e.toJson()).toList(),
      'itemType': itemType.name,
    };
  }
}

class TagPageMoreArtistPageModel {
  final List<BaseArtistModel> artists;
  final String? nextPageUrl;
  final String? previousPageUrl;
  final String? currentPageUrl;
  final String? firstPageUrl;
  final String? lastPageUrl;
  final int totalPages;

  TagPageMoreArtistPageModel({
    required this.artists,
    this.nextPageUrl,
    this.previousPageUrl,
    this.currentPageUrl,
    this.firstPageUrl,
    this.lastPageUrl,
    this.totalPages = 0,
  });

  factory TagPageMoreArtistPageModel.fromJson(Map<String, dynamic> json) {
    return TagPageMoreArtistPageModel(
      artists: (json['artists'] as List)
          .map((e) => BaseArtistModel.fromJson(e))
          .toList(),
      nextPageUrl: json['nextPageUrl'],
      previousPageUrl: json['previousPageUrl'],
      currentPageUrl: json['currentPageUrl'],
      firstPageUrl: json['firstPageUrl'],
      lastPageUrl: json['lastPageUrl'],
      totalPages: int.tryParse(json['totalPages']) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'artists': artists.map((e) => e.toJson()).toList(),
      'nextPageUrl': nextPageUrl,
      'previousPageUrl': previousPageUrl,
      'currentPageUrl': currentPageUrl,
      'firstPageUrl': firstPageUrl,
      'lastPageUrl': lastPageUrl,
      'totalPages': totalPages,
    };
  }
}

class TagPageMoreAlbumPageModel {
  final List<BaseAlbumModel> albums;
  final String? nextPageUrl;
  final String? previousPageUrl;
  final String? currentPageUrl;
  final String? firstPageUrl;
  final String? lastPageUrl;
  final int totalPages;

  TagPageMoreAlbumPageModel({
    required this.albums,
    this.nextPageUrl,
    this.previousPageUrl,
    this.currentPageUrl,
    this.firstPageUrl,
    this.lastPageUrl,
    this.totalPages = 0,
  });

  factory TagPageMoreAlbumPageModel.fromJson(Map<String, dynamic> json) {
    return TagPageMoreAlbumPageModel(
      albums: (json['albums'] as List)
          .map((e) => BaseAlbumModel.fromJson(e))
          .toList(),
      nextPageUrl: json['nextPageUrl'],
      previousPageUrl: json['previousPageUrl'],
      currentPageUrl: json['currentPageUrl'],
      firstPageUrl: json['firstPageUrl'],
      lastPageUrl: json['lastPageUrl'],
      totalPages: int.tryParse(json['totalPages']) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'albums': albums.map((e) => e.toJson()).toList(),
      'nextPageUrl': nextPageUrl,
      'previousPageUrl': previousPageUrl,
      'currentPageUrl': currentPageUrl,
      'firstPageUrl': firstPageUrl,
      'lastPageUrl': lastPageUrl,
      'totalPages': totalPages,
    };
  }
}

class TagPageMoreTrackPageModel {
  final List<BaseTrackModel> tracks;
  final String? nextPageUrl;
  final String? previousPageUrl;
  final String? currentPageUrl;
  final String? firstPageUrl;
  final String? lastPageUrl;
  final int totalPages;

  TagPageMoreTrackPageModel({
    required this.tracks,
    this.nextPageUrl,
    this.previousPageUrl,
    this.currentPageUrl,
    this.firstPageUrl,
    this.lastPageUrl,
    this.totalPages = 0,
  });

  factory TagPageMoreTrackPageModel.fromJson(Map<String, dynamic> json) {
    return TagPageMoreTrackPageModel(
      tracks: (json['tracks'] as List)
          .map((e) => BaseTrackModel.fromJson(e))
          .toList(),
      nextPageUrl: json['nextPageUrl'],
      previousPageUrl: json['previousPageUrl'],
      currentPageUrl: json['currentPageUrl'],
      firstPageUrl: json['firstPageUrl'],
      lastPageUrl: json['lastPageUrl'],
      totalPages: int.tryParse(json['totalPages']) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tracks': tracks.map((e) => e.toJson()).toList(),
      'nextPageUrl': nextPageUrl,
      'previousPageUrl': previousPageUrl,
      'currentPageUrl': currentPageUrl,
      'firstPageUrl': firstPageUrl,
      'lastPageUrl': lastPageUrl,
      'totalPages': totalPages,
    };
  }
}

class SongInfo {
  final String streamUrl;
  final String? audioCodec;
  final Bitrate? bitrate;
  final String? qualityLabel;
  final FileSize? fileSize;

  SongInfo({
    required this.streamUrl,
    this.audioCodec,
    this.bitrate,
    this.qualityLabel,
    this.fileSize,
  });

  factory SongInfo.fromJson(Map<String, dynamic> json) {
    return SongInfo(
      streamUrl: json['streamUrl'],
      audioCodec: json['audioCodec'],
      bitrate:
          json['bitrate'] != null ? Bitrate.fromJson(json['bitrate']) : null,
      qualityLabel: json['qualityLabel'],
      fileSize:
          json['fileSize'] != null ? FileSize.fromJson(json['fileSize']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'streamUrl': streamUrl,
      'audioCodec': audioCodec,
      'bitrate': bitrate?.toJson(),
      'qualityLabel': qualityLabel,
      'fileSize': fileSize?.toJson(),
    };
  }
}
