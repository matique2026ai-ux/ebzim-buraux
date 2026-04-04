export interface CloudinaryResponse {
    url: string;
    public_id: string;
    resource_type: string;
    format: string;
}
export declare class MediaService {
    uploadImage(file: any, folder?: string): Promise<CloudinaryResponse>;
    deleteMedia(publicId: string): Promise<any>;
}
