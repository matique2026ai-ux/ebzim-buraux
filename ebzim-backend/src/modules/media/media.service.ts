import { Injectable, BadRequestException } from '@nestjs/common';
import { v2 as cloudinary } from 'cloudinary';
import * as streamifier from 'streamifier';

export interface CloudinaryResponse {
  url: string;
  public_id: string;
  resource_type: string;
  format: string;
}

@Injectable()
export class MediaService {
  
  async uploadImage(file: any, folder = 'ebzim/uploads'): Promise<CloudinaryResponse> {
    
    // Strict MIME boundary validation
    if (!file.mimetype.match(/^(image\/(jpeg|png|gif|webp)|video\/(mp4|webm))$/)) {
      throw new BadRequestException('Invalid file type. Only jpeg, png, gif, webp imagery or mp4, webm videos are allowed.');
    }

    // Increased limit for institutional media content (images/videos)
    const MAX_MB = 20;
    if (file.size > MAX_MB * 1024 * 1024) {
      throw new BadRequestException(`File size exceeds strict ${MAX_MB}MB limit.`);
    }

    return new Promise<CloudinaryResponse>((resolve, reject) => {
      const uploadStream = cloudinary.uploader.upload_stream(
        { folder, resource_type: 'auto' }, // Preparation for handling diverse media later
        (error: any, result: any) => {
          if (error) return reject(error);
          resolve({
            url: result.secure_url,
            public_id: result.public_id,
            resource_type: result.resource_type,
            format: result.format,
          });
        },
      );

      streamifier.createReadStream(file.buffer).pipe(uploadStream);
    });
  }

  async deleteMedia(publicId: string): Promise<any> {
    return new Promise((resolve, reject) => {
      cloudinary.uploader.destroy(publicId, (error: any, result: any) => {
        if (error) return reject(error);
        resolve(result);
      });
    });
  }
}
