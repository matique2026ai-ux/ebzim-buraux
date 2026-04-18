import { Model } from 'mongoose';
import { LeaderDocument } from './schemas/leader.schema';
import { CreateLeaderDto, UpdateLeaderDto } from './dto/create-leader.dto';
export declare class LeadershipService {
    private leaderModel;
    constructor(leaderModel: Model<LeaderDocument>);
    findAll(): Promise<(import("mongoose").Document<unknown, {}, LeaderDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/leader.schema").Leader & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    })[]>;
    create(dto: CreateLeaderDto): Promise<import("mongoose").Document<unknown, {}, LeaderDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/leader.schema").Leader & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }>;
    update(id: string, dto: UpdateLeaderDto): Promise<(import("mongoose").Document<unknown, {}, LeaderDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/leader.schema").Leader & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }) | null>;
    delete(id: string): Promise<(import("mongoose").Document<unknown, {}, LeaderDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/leader.schema").Leader & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }) | null>;
}
